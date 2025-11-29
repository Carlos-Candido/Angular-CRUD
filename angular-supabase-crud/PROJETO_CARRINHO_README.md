# 🛒 Sistema de E-commerce com Angular + Supabase

Sistema completo de gerenciamento de produtos com carrinho de compras desenvolvido em Angular 18 e Supabase.

## ✨ Funcionalidades Implementadas

### 🔐 Autenticação

- ✅ Login de usuários existentes
- ✅ Cadastro de novos usuários (register)
- ✅ Logout com redirecionamento
- ✅ Guard de autenticação protegendo rotas

### 📦 Gerenciamento de Produtos

- ✅ Listagem de produtos em tabela Material Design
- ✅ Adicionar novos produtos (CRUD)
- ✅ Editar produtos existentes
- ✅ Excluir produtos
- ✅ Upload de imagem (URL)
- ✅ Botão "Adicionar ao Carrinho" em cada produto

### 🛒 Carrinho de Compras

- ✅ Adicionar produtos ao carrinho
- ✅ Incrementar/Decrementar quantidade (botões +/-)
- ✅ Quantidade mínima = 1 (não permite valores menores)
- ✅ Remover item individual do carrinho (botão delete)
- ✅ Cálculo automático do total parcial (preço × quantidade)
- ✅ Cálculo do total geral do carrinho
- ✅ Badge com contador de itens no ícone do carrinho
- ✅ Persistência do carrinho no localStorage

### 💳 Checkout e Finalização

- ✅ Campo para informar CEP do cliente
- ✅ Cálculo automático do frete
- ✅ **Frete GRÁTIS** para compras acima de R$ 100,00
- ✅ Resumo completo do pedido antes de finalizar
- ✅ Opções: Confirmar, Cancelar ou Continuar Comprando
- ✅ Salvamento do pedido no banco de dados
- ✅ Limpeza automática do carrinho após finalizar

## 🗄️ Estrutura do Banco de Dados

### Tabelas Criadas

#### 1. `products` - Catálogo de Produtos

```sql
- id (BIGINT, Primary Key, Auto-increment)
- name (TEXT, NOT NULL)
- price (NUMERIC, CHECK >= 0)
- description (TEXT, NULLABLE)
- imageUrl (TEXT, NULLABLE)
- createdAt (TIMESTAMPTZ, DEFAULT NOW)
```

#### 2. `orders` - Pedidos dos Clientes

```sql
- id (BIGINT, Primary Key, Auto-increment)
- userId (UUID, Foreign Key -> auth.users)
- cep (VARCHAR(8), NOT NULL)
- subtotal (NUMERIC, CHECK >= 0)
- frete (NUMERIC, CHECK >= 0)
- total (NUMERIC, CHECK >= 0, calculado automaticamente)
- createdAt (TIMESTAMPTZ, DEFAULT NOW)
```

#### 3. `order_items` - Itens de Cada Pedido

```sql
- id (BIGINT, Primary Key, Auto-increment)
- orderId (BIGINT, Foreign Key -> orders)
- productId (BIGINT, Foreign Key -> products)
- productName (TEXT, NOT NULL)
- productPrice (NUMERIC, CHECK >= 0)
- quantity (INTEGER, CHECK > 0)
- subtotal (NUMERIC, CHECK >= 0)
```

### Segurança (RLS - Row Level Security)

✅ RLS habilitado em todas as tabelas  
✅ Políticas de segurança configuradas:

- Usuários autenticados podem ler/escrever produtos
- Usuários só visualizam seus próprios pedidos
- Itens do pedido seguem a mesma política do pedido pai

## 🚀 Como Configurar

### 1. Configurar Supabase

1. Acesse o [Supabase](https://supabase.com) e crie um novo projeto
2. No **SQL Editor**, execute o script `DATABASE_SCHEMA.sql` completo
3. Copie a **URL** e **anon key** do seu projeto

### 2. Configurar Ambiente Angular

Edite o arquivo `src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  supabaseUrl: "SUA_URL_DO_SUPABASE",
  supabaseKey: "SUA_ANON_KEY_DO_SUPABASE",
};
```

### 3. Instalar Dependências

```bash
npm install
```

### 4. Executar o Projeto

```bash
npm start
# ou
ng serve
```

Acesse: `http://localhost:4200`

## 📋 Fluxo de Uso

### 1️⃣ Cadastro/Login

- Acesse `/register` para criar uma conta
- Ou faça login em `/login` se já tiver conta

### 2️⃣ Gerenciar Produtos

- Navegue até `/products`
- Adicione, edite ou exclua produtos
- Clique em "Adicionar ao Carrinho" para adicionar produtos

### 3️⃣ Visualizar Carrinho

- Clique no ícone do carrinho (badge mostra quantidade)
- Ajuste quantidades com os botões + e -
- Remova itens indesejados
- Visualize o total em tempo real

### 4️⃣ Finalizar Compra

- No carrinho, clique em "Finalizar Compra"
- Informe o CEP (8 dígitos)
- Clique em "Calcular Frete"
  - **Frete grátis** se subtotal ≥ R$ 100,00
  - Caso contrário, será cobrado frete
- Revise o resumo completo do pedido
- Clique em "Confirmar Pedido" para finalizar
- Ou "Cancelar" / "Continuar Comprando"

## 📁 Estrutura de Arquivos

```
src/app/
├── auth/
│   ├── login/          # Componente de login
│   └── register/       # Componente de cadastro
├── guards/
│   └── auth.guard.ts   # Proteção de rotas
├── models/
│   ├── product.ts      # Interface de produto
│   └── cart.ts         # Interfaces de carrinho e pedido
├── services/
│   ├── supabase.service.ts  # Integração com Supabase
│   └── cart.service.ts      # Lógica do carrinho
├── home/               # Página inicial
├── products/           # CRUD de produtos
├── cart/               # Carrinho de compras
├── checkout/           # Finalização do pedido
└── app.routes.ts       # Rotas da aplicação
```

## 🎨 Tecnologias Utilizadas

- **Angular 18** - Framework principal
- **Angular Material** - Componentes UI
- **Supabase** - Backend as a Service (BaaS)
  - Autenticação
  - PostgreSQL
  - Row Level Security (RLS)
- **TypeScript** - Linguagem
- **RxJS Signals** - Gerenciamento de estado reativo

## ✅ Requisitos Atendidos

### Tela de Listagem de Produtos

- ✅ Exibe dados do produto
- ✅ Botões: Editar, Excluir, Adicionar ao Carrinho
- ✅ Se produto não está no carrinho → adiciona com quantidade = 1
- ✅ Se produto já está no carrinho → incrementa quantidade

### Tela do Carrinho

- ✅ Lista de itens adicionados
- ✅ Exibe: produto, quantidade, total parcial
- ✅ Total geral calculado automaticamente

### Incrementar/Decrementar

- ✅ Botão "+" aumenta quantidade
- ✅ Botão "-" diminui quantidade
- ✅ Não permite quantidade < 1
- ✅ Recalcula totais em tempo real

### Remover Item

- ✅ Botão com ícone delete (Material Icons)
- ✅ Remove item individual
- ✅ Atualiza lista imediatamente
- ✅ Recalcula total geral automaticamente

### CEP e Frete

- ✅ Campo para informar CEP do cliente
- ✅ Cálculo de frete implementado
- ✅ **Frete GRÁTIS** acima de R$ 100,00

### Resumo e Confirmação

- ✅ Resumo completo antes de finalizar
- ✅ Botões: Confirmar, Cancelar, Continuar Comprando
- ✅ Salva pedido no banco ao confirmar
- ✅ Limpa carrinho após finalizar

## 📝 Arquivo SQL do Banco

O código SQL completo está no arquivo: **`DATABASE_SCHEMA.sql`**

Execute todo o conteúdo desse arquivo no SQL Editor do Supabase para criar:

- ✅ Todas as tabelas (products, orders, order_items)
- ✅ Índices de otimização
- ✅ Políticas de segurança (RLS)
- ✅ Triggers automáticos
- ✅ Views úteis
- ✅ Dados de exemplo (seeds)

## 🔒 Segurança

- Autenticação obrigatória para acessar o sistema
- RLS protege dados sensíveis
- Usuários só veem seus próprios pedidos
- Validações de integridade no banco
- Guards protegem rotas não autorizadas

## 📞 Suporte

Para dúvidas ou problemas, verifique:

1. Se o script SQL foi executado corretamente
2. Se as credenciais do Supabase estão corretas em `environment.ts`
3. Se todas as dependências foram instaladas (`npm install`)
4. Se o servidor está rodando (`ng serve`)

---

**Desenvolvido com Angular 18 + Supabase** 🚀
