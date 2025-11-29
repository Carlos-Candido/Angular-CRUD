import { Product } from "./product";

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface Order {
  id?: number;
  userId: string;
  cep: string;
  subtotal: number;
  frete: number;
  total: number;
  createdAt?: string;
}

export interface OrderItem {
  id?: number;
  orderId: number;
  productId: number;
  productName: string;
  productPrice: number;
  quantity: number;
  subtotal: number;
}
