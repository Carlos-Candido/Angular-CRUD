import { Component, computed } from "@angular/core";
import { CommonModule } from "@angular/common";
import { Router, RouterModule } from "@angular/router";
import { MatButtonModule } from "@angular/material/button";
import { MatIconModule } from "@angular/material/icon";
import { MatTooltipModule } from "@angular/material/tooltip";
import { MatCardModule } from "@angular/material/card";
import { CartService } from "../services/cart.service";

@Component({
  selector: "app-cart",
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    MatButtonModule,
    MatIconModule,
    MatTooltipModule,
    MatCardModule,
  ],
  templateUrl: "./cart.component.html",
  styleUrls: ["./cart.component.css"],
})
export class CartComponent {
  items = computed(() => this.cartService.items());
  subtotal = computed(() => this.cartService.subtotal());
  itemCount = computed(() => this.cartService.itemCount());

  constructor(private cartService: CartService, private router: Router) {}

  incrementQuantity(productId: number) {
    this.cartService.incrementQuantity(productId);
  }

  decrementQuantity(productId: number) {
    this.cartService.decrementQuantity(productId);
  }

  removeItem(productId: number) {
    if (confirm("Tem certeza que deseja remover este item do carrinho?")) {
      this.cartService.removeFromCart(productId);
    }
  }

  getItemTotal(productId: number, quantity: number, price: number): number {
    return quantity * price;
  }

  goToCheckout() {
    if (this.items().length === 0) {
      alert("Seu carrinho está vazio!");
      return;
    }
    this.router.navigate(["/checkout"]);
  }

  onImageError(event: Event): void {
    const img = event.target as HTMLImageElement;
    img.src = "https://via.placeholder.com/100?text=Sem+Imagem";
  }
}
