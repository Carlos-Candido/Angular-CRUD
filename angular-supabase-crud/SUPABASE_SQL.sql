-- ============================================
-- CÓDIGO SQL SIMPLIFICADO - COPIE E COLE NO SUPABASE
-- Execute este código completo no SQL Editor do Supabase
-- ============================================

-- 1. TABELA DE PRODUTOS
CREATE TABLE IF NOT EXISTS public.products (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
  description TEXT,
  "imageUrl" TEXT,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS products_created_at_idx ON public.products ("createdAt" DESC);
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products read for authenticated" ON public.products FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Products write for authenticated" ON public.products FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Products update for authenticated" ON public.products FOR UPDATE USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Products delete for authenticated" ON public.products FOR DELETE USING (auth.role() = 'authenticated');

-- 2. TABELA DE PEDIDOS
CREATE TABLE IF NOT EXISTS public.orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "userId" UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  cep VARCHAR(8) NOT NULL,
  subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0),
  frete NUMERIC(12,2) NOT NULL CHECK (frete >= 0),
  total NUMERIC(12,2) NOT NULL CHECK (total >= 0),
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

CREATE INDEX IF NOT EXISTS orders_user_id_idx ON public.orders ("userId");
CREATE INDEX IF NOT EXISTS orders_created_at_idx ON public.orders ("createdAt" DESC);
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own orders" ON public.orders FOR SELECT USING (auth.uid() = "userId");
CREATE POLICY "Users can create their own orders" ON public.orders FOR INSERT WITH CHECK (auth.uid() = "userId");

-- 3. TABELA DE ITENS DO PEDIDO
CREATE TABLE IF NOT EXISTS public.order_items (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "orderId" BIGINT NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  "productId" BIGINT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  "productName" TEXT NOT NULL,
  "productPrice" NUMERIC(12,2) NOT NULL CHECK ("productPrice" >= 0),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0)
);

CREATE INDEX IF NOT EXISTS order_items_order_id_idx ON public.order_items ("orderId");
CREATE INDEX IF NOT EXISTS order_items_product_id_idx ON public.order_items ("productId");
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own order items" ON public.order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.orders WHERE orders.id = order_items."orderId" AND orders."userId" = auth.uid())
);
CREATE POLICY "Users can create order items for their orders" ON public.order_items FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM public.orders WHERE orders.id = order_items."orderId" AND orders."userId" = auth.uid())
);

-- 4. DADOS DE EXEMPLO (SEEDS)
INSERT INTO public.products (name, price, description, "imageUrl")
VALUES
  ('Notebook Gamer', 7599.99, 'RTX 4060, 16 GB RAM, SSD 1 TB', 'https://via.placeholder.com/300x200?text=Notebook'),
  ('Headset Wireless', 899.90, 'Cancelamento ativo de ruído, 30h bateria', 'https://via.placeholder.com/300x200?text=Headset'),
  ('Teclado Mecânico', 499.00, 'Switch azul, RGB, ABNT2', 'https://via.placeholder.com/300x200?text=Teclado'),
  ('Mouse Gamer', 299.90, 'RGB, 16000 DPI, 8 botões programáveis', 'https://via.placeholder.com/300x200?text=Mouse'),
  ('Monitor 27"', 1899.00, '2K, 165Hz, IPS, HDR', 'https://via.placeholder.com/300x200?text=Monitor'),
  ('Webcam Full HD', 349.90, '1080p, 60fps, microfone integrado', 'https://via.placeholder.com/300x200?text=Webcam')
ON CONFLICT DO NOTHING;

-- ============================================
-- PRONTO! Seu banco está configurado ✅
-- ============================================
