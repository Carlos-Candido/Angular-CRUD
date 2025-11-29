import { Injectable, signal, computed } from "@angular/core";
import { CartItem } from "../models/cart";
import { Product } from "../models/product";

@Injectable({
  providedIn: "root",
})
export class CartService {
  // Estado do carrinho
  private cartItems = signal<CartItem[]>([]);

  // Computed values
  items = computed(() => this.cartItems());

  itemCount = computed(() => {
    return this.cartItems().reduce((total, item) => total + item.quantity, 0);
  });

  subtotal = computed(() => {
    return this.cartItems().reduce(
      (total, item) => total + item.product.price * item.quantity,
      0
    );
  });

  constructor() {
    // Carregar carrinho do localStorage
    const savedCart = localStorage.getItem("cart");
    if (savedCart) {
      try {
        this.cartItems.set(JSON.parse(savedCart));
      } catch (e) {
        console.error("Erro ao carregar carrinho:", e);
      }
    }
  }

  private saveCart() {
    localStorage.setItem("cart", JSON.stringify(this.cartItems()));
  }

  addToCart(product: Product) {
    const currentItems = this.cartItems();
    const existingItem = currentItems.find(
      (item) => item.product.id === product.id
    );

    if (existingItem) {
      // Incrementar quantidade se já existe
      existingItem.quantity++;
      this.cartItems.set([...currentItems]);
    } else {
      // Adicionar novo item
      this.cartItems.set([...currentItems, { product, quantity: 1 }]);
    }

    this.saveCart();
  }

  updateQuantity(productId: number, quantity: number) {
    if (quantity < 1) return;

    const currentItems = this.cartItems();
    const item = currentItems.find((item) => item.product.id === productId);

    if (item) {
      item.quantity = quantity;
      this.cartItems.set([...currentItems]);
      this.saveCart();
    }
  }

  incrementQuantity(productId: number) {
    const currentItems = this.cartItems();
    const item = currentItems.find((item) => item.product.id === productId);

    if (item) {
      item.quantity++;
      this.cartItems.set([...currentItems]);
      this.saveCart();
    }
  }

  decrementQuantity(productId: number) {
    const currentItems = this.cartItems();
    const item = currentItems.find((item) => item.product.id === productId);

    if (item && item.quantity > 1) {
      item.quantity--;
      this.cartItems.set([...currentItems]);
      this.saveCart();
    }
  }

  removeFromCart(productId: number) {
    const currentItems = this.cartItems();
    this.cartItems.set(
      currentItems.filter((item) => item.product.id !== productId)
    );
    this.saveCart();
  }

  clearCart() {
    this.cartItems.set([]);
    localStorage.removeItem("cart");
  }

  getItemTotal(item: CartItem): number {
    return item.product.price * item.quantity;
  }
}
