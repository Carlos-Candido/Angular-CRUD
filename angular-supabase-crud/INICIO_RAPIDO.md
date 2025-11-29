# ⚡ INÍCIO RÁPIDO

## 🎯 3 Passos para Rodar o Projeto

### 1️⃣ Execute o SQL no Supabase

```
1. Acesse seu projeto no Supabase
2. Vá em "SQL Editor"
3. Copie TODO o conteúdo do arquivo: SUPABASE_SQL.sql
4. Cole e execute (botão "Run")
```

### 2️⃣ Configure as Credenciais

```typescript
// Edite: src/environments/environment.ts

export const environment = {
  production: false,
  supabaseUrl: "COLE_SUA_URL_AQUI",
  supabaseKey: "COLE_SUA_KEY_AQUI",
};
```

**Onde encontrar URL e KEY:**

- Supabase → Seu Projeto → Settings → API
- Copie: Project URL
- Copie: anon public (Key)

### 3️⃣ Execute o Projeto

```bash
npm install
npm start
```

Acesse: **http://localhost:4200**

---

## 🧪 Como Testar

1. **Cadastrar Usuário**

   - Clique em "Cadastre-se"
   - Preencha email e senha
   - Confirme a senha

2. **Fazer Login**

   - Use o email cadastrado
   - Faça login

3. **Adicionar Produtos ao Carrinho**

   - Vá em "Ver Produtos"
   - Clique em "Adicionar" em alguns produtos
   - Observe o badge do carrinho aumentar

4. **Ver Carrinho**

   - Clique no ícone do carrinho (canto superior)
   - Teste os botões + e -
   - Remova algum item (ícone lixeira)
   - Veja o total sendo calculado

5. **Finalizar Compra**
   - Clique em "Finalizar Compra"
   - Digite um CEP (ex: 12345678)
   - Clique em "Calcular Frete"
   - Se total < R$ 100 → cobra frete
   - Se total ≥ R$ 100 → **FRETE GRÁTIS!** 🎉
   - Revise o resumo
   - Clique em "Confirmar Pedido"

---

## 📦 O que foi implementado?

✅ Cadastro de usuários  
✅ Login/Logout  
✅ CRUD de produtos  
✅ Adicionar ao carrinho  
✅ Incrementar/Decrementar quantidade  
✅ Remover item do carrinho  
✅ Cálculo de totais  
✅ Campo de CEP  
✅ Frete grátis acima de R$ 100  
✅ Resumo do pedido  
✅ Salvar pedido no banco  
✅ Limpar carrinho após compra

---

## 🗄️ Código SQL

Execute este arquivo no Supabase:
👉 **`SUPABASE_SQL.sql`**

Ele cria:

- Tabela `products` (catálogo)
- Tabela `orders` (pedidos)
- Tabela `order_items` (itens do pedido)
- Políticas de segurança (RLS)
- Produtos de exemplo

---

## 📚 Documentação Completa

Para entender tudo em detalhes, leia:

- `RESUMO_PROJETO.md` → Checklist completo
- `PROJETO_CARRINHO_README.md` → Documentação técnica
- `DATABASE_SCHEMA.sql` → SQL comentado

---

## ❓ Problemas Comuns

### Erro: "Invalid JWT"

**Solução:** Verifique se a `supabaseKey` está correta em `environment.ts`

### Erro: "Permission denied"

**Solução:** Execute o SQL completo novamente (cria as políticas RLS)

### Produtos não aparecem

**Solução:** Verifique se o SQL foi executado (cria os produtos de exemplo)

### Não consigo fazer login

**Solução:** Cadastre um usuário primeiro em `/register`

---

## 🎉 Pronto!

Seu sistema de e-commerce está funcionando! 🛒

**Dúvidas?** Leia os arquivos de documentação completa.
