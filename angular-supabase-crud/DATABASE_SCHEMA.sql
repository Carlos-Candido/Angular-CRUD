-- ============================================
-- BANCO DE DADOS COMPLETO - ANGULAR SUPABASE CRUD
-- Sistema de E-commerce com Carrinho de Compras
-- ============================================

-- 1. TABELA DE PRODUTOS
-- ============================================
CREATE TABLE IF NOT EXISTS public.products (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
  description TEXT,
  "imageUrl" TEXT,
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- Índice para ordenação por data de criação
CREATE INDEX IF NOT EXISTS products_created_at_idx
  ON public.products ("createdAt" DESC);

-- RLS (Row Level Security) para produtos
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança para produtos
CREATE POLICY "Products read for authenticated"
  ON public.products
  FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Products write for authenticated"
  ON public.products
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Products update for authenticated"
  ON public.products
  FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Products delete for authenticated"
  ON public.products
  FOR DELETE
  USING (auth.role() = 'authenticated');

-- ============================================
-- 2. TABELA DE PEDIDOS (ORDERS)
-- ============================================
CREATE TABLE IF NOT EXISTS public.orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "userId" UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  cep VARCHAR(8) NOT NULL,
  subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0),
  frete NUMERIC(12,2) NOT NULL CHECK (frete >= 0),
  total NUMERIC(12,2) NOT NULL CHECK (total >= 0),
  "createdAt" TIMESTAMPTZ NOT NULL DEFAULT timezone('utc', now())
);

-- Índices para otimização de consultas
CREATE INDEX IF NOT EXISTS orders_user_id_idx
  ON public.orders ("userId");

CREATE INDEX IF NOT EXISTS orders_created_at_idx
  ON public.orders ("createdAt" DESC);

-- RLS para pedidos
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança para pedidos (usuário só vê seus próprios pedidos)
CREATE POLICY "Users can view their own orders"
  ON public.orders
  FOR SELECT
  USING (auth.uid() = "userId");

CREATE POLICY "Users can create their own orders"
  ON public.orders
  FOR INSERT
  WITH CHECK (auth.uid() = "userId");

-- ============================================
-- 3. TABELA DE ITENS DO PEDIDO (ORDER_ITEMS)
-- ============================================
CREATE TABLE IF NOT EXISTS public.order_items (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  "orderId" BIGINT NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  "productId" BIGINT NOT NULL REFERENCES public.products(id) ON DELETE RESTRICT,
  "productName" TEXT NOT NULL,
  "productPrice" NUMERIC(12,2) NOT NULL CHECK ("productPrice" >= 0),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0)
);

-- Índices para otimização
CREATE INDEX IF NOT EXISTS order_items_order_id_idx
  ON public.order_items ("orderId");

CREATE INDEX IF NOT EXISTS order_items_product_id_idx
  ON public.order_items ("productId");

-- RLS para itens do pedido
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança (usuário vê apenas itens dos seus pedidos)
CREATE POLICY "Users can view their own order items"
  ON public.order_items
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.orders
      WHERE orders.id = order_items."orderId"
      AND orders."userId" = auth.uid()
    )
  );

CREATE POLICY "Users can create order items for their orders"
  ON public.order_items
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.orders
      WHERE orders.id = order_items."orderId"
      AND orders."userId" = auth.uid()
    )
  );

-- ============================================
-- 4. DADOS INICIAIS (SEEDS)
-- ============================================

-- Inserir produtos de exemplo
INSERT INTO public.products (name, price, description, "imageUrl")
VALUES
  ('Notebook Gamer', 7599.99, 'RTX 4060, 16 GB RAM, SSD 1 TB', 'https://via.placeholder.com/300x200?text=Notebook'),
  ('Headset Wireless', 899.90, 'Cancelamento ativo de ruído, 30h bateria', 'https://via.placeholder.com/300x200?text=Headset'),
  ('Teclado Mecânico', 499.00, 'Switch azul, RGB, ABNT2', 'https://via.placeholder.com/300x200?text=Teclado'),
  ('Mouse Gamer', 299.90, 'RGB, 16000 DPI, 8 botões programáveis', 'https://via.placeholder.com/300x200?text=Mouse'),
  ('Monitor 27"', 1899.00, '2K, 165Hz, IPS, HDR', 'https://via.placeholder.com/300x200?text=Monitor'),
  ('Webcam Full HD', 349.90, '1080p, 60fps, microfone integrado', 'https://via.placeholder.com/300x200?text=Webcam'),
  ('SSD 1TB', 549.00, 'NVMe, leitura 3500MB/s', 'https://via.placeholder.com/300x200?text=SSD'),
  ('Cadeira Gamer', 1299.00, 'Ergonômica, reclinável 180°, almofadas', 'https://via.placeholder.com/300x200?text=Cadeira')
ON CONFLICT DO NOTHING;

-- ============================================
-- 5. FUNÇÕES ÚTEIS (OPCIONAL)
-- ============================================

-- Função para calcular o total do pedido automaticamente
CREATE OR REPLACE FUNCTION calculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
  NEW.total := NEW.subtotal + NEW.frete;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para calcular total antes de inserir/atualizar
DROP TRIGGER IF EXISTS trigger_calculate_order_total ON public.orders;
CREATE TRIGGER trigger_calculate_order_total
  BEFORE INSERT OR UPDATE ON public.orders
  FOR EACH ROW
  EXECUTE FUNCTION calculate_order_total();

-- ============================================
-- 6. VIEWS ÚTEIS (OPCIONAL)
-- ============================================

-- View para ver pedidos com informações do usuário
CREATE OR REPLACE VIEW orders_with_user AS
SELECT 
  o.id,
  o."userId",
  u.email as user_email,
  o.cep,
  o.subtotal,
  o.frete,
  o.total,
  o."createdAt",
  (SELECT COUNT(*) FROM order_items WHERE "orderId" = o.id) as item_count
FROM orders o
LEFT JOIN auth.users u ON o."userId" = u.id;

-- View para ver itens do pedido com detalhes do produto
CREATE OR REPLACE VIEW order_items_detailed AS
SELECT 
  oi.id,
  oi."orderId",
  oi."productId",
  oi."productName",
  oi."productPrice",
  oi.quantity,
  oi.subtotal,
  p.name as current_product_name,
  p.price as current_product_price,
  p."imageUrl"
FROM order_items oi
LEFT JOIN products p ON oi."productId" = p.id;

-- ============================================
-- RESUMO DAS TABELAS:
-- ============================================
-- ✅ products: Catálogo de produtos
-- ✅ orders: Pedidos realizados pelos clientes
-- ✅ order_items: Itens individuais de cada pedido
--
-- FUNCIONALIDADES:
-- ✅ RLS habilitado em todas as tabelas
-- ✅ Usuários só veem seus próprios pedidos
-- ✅ Cálculo automático do total do pedido
-- ✅ Validações de integridade (CHECK constraints)
-- ✅ Índices para otimização de consultas
-- ✅ Cascade delete para manter integridade
-- ============================================
