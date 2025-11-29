import { Component, computed } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";
import { Router, RouterModule } from "@angular/router";
import { MatButtonModule } from "@angular/material/button";
import { MatIconModule } from "@angular/material/icon";
import { MatInputModule } from "@angular/material/input";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatCardModule } from "@angular/material/card";
import { MatDividerModule } from "@angular/material/divider";
import { MatProgressSpinnerModule } from "@angular/material/progress-spinner";
import { CartService } from "../services/cart.service";
import { SupabaseService } from "../services/supabase.service";
import { Order, OrderItem } from "../models/cart";

@Component({
  selector: "app-checkout",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    MatButtonModule,
    MatIconModule,
    MatInputModule,
    MatFormFieldModule,
    MatCardModule,
    MatDividerModule,
    MatProgressSpinnerModule,
  ],
  templateUrl: "./checkout.component.html",
  styleUrls: ["./checkout.component.css"],
})
export class CheckoutComponent {
  items = computed(() => this.cartService.items());
  subtotal = computed(() => this.cartService.subtotal());
  itemCount = computed(() => this.cartService.itemCount());

  cep: string = "";
  frete: number = 0;
  showSummary: boolean = false;
  loading: boolean = false;

  constructor(
    private cartService: CartService,
    private supabaseService: SupabaseService,
    private router: Router
  ) {}

  get total(): number {
    return this.subtotal() + this.frete;
  }

  calculateFrete() {
    if (!this.cep || this.cep.length < 8) {
      alert("Por favor, informe um CEP válido com 8 dígitos!");
      return;
    }

    // Frete grátis para compras acima de R$ 100,00
    if (this.subtotal() >= 100) {
      this.frete = 0;
    } else {
      // Simular cálculo de frete baseado no CEP
      // Em produção, integrar com API de frete (Correios, Jadlog, etc.)
      this.frete = 15.0;
    }

    this.showSummary = true;
  }

  continueShopping() {
    this.router.navigate(["/products"]);
  }

  cancelOrder() {
    if (confirm("Tem certeza que deseja cancelar o pedido?")) {
      this.showSummary = false;
      this.cep = "";
      this.frete = 0;
    }
  }

  async finalizePurchase() {
    if (!this.showSummary) {
      alert("Por favor, calcule o frete primeiro!");
      return;
    }

    if (this.items().length === 0) {
      alert("Seu carrinho está vazio!");
      return;
    }

    const userId = this.supabaseService.user()?.id;
    if (!userId) {
      alert("Você precisa estar logado para finalizar a compra!");
      this.router.navigate(["/login"]);
      return;
    }

    this.loading = true;

    try {
      // Criar o pedido no banco
      const order: Order = {
        userId: userId,
        cep: this.cep,
        subtotal: this.subtotal(),
        frete: this.frete,
        total: this.total,
        createdAt: new Date().toISOString(),
      };

      const orderId = await this.supabaseService.createOrder(order);

      // Criar os itens do pedido
      const orderItems: OrderItem[] = this.items().map((item) => ({
        orderId: orderId,
        productId: item.product.id!,
        productName: item.product.name,
        productPrice: item.product.price,
        quantity: item.quantity,
        subtotal: item.product.price * item.quantity,
      }));

      await this.supabaseService.createOrderItems(orderItems);

      // Limpar carrinho
      this.cartService.clearCart();

      alert("Pedido finalizado com sucesso! Obrigado pela sua compra!");
      this.router.navigate(["/products"]);
    } catch (error) {
      console.error("Erro ao finalizar pedido:", error);
      alert("Erro ao finalizar pedido. Tente novamente.");
    } finally {
      this.loading = false;
    }
  }

  formatCep(event: any) {
    let value = event.target.value.replace(/\D/g, "");
    if (value.length > 8) {
      value = value.substring(0, 8);
    }
    this.cep = value;
  }
}
