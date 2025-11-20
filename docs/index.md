# 📚 DOCS/index.md - Expense Control APP

## Índice da Documentação

Bem-vindo à documentação completa do **Expense Control APP** - Sistema de Controle Financeiro Pessoal.

---

## 📖 Documentação Geral

### [🏗️ Arquitetura do Projeto](./architecture.md)
Descrição detalhada da arquitetura MVVM, padrões de projeto, organização de código e boas práticas utilizadas no desenvolvimento do aplicativo Flutter.

**Tópicos:**
- Padrão MVVM (Model-View-ViewModel)
- Gerenciamento de Estado com Riverpod
- Injeção de Dependências
- Clean Architecture
- Separation of Concerns

### [🔧 Backend e Persistência](./backend.md)
Documentação sobre a estratégia de persistência de dados, sincronização e integração com Firebase.

**Tópicos:**
- Drift (SQLite) - Banco de Dados Local
- Firebase Authentication
- Firebase Firestore - Sincronização
- Estratégia Offline-First
- Resolução de Conflitos

### [📁 Estrutura de Pastas](./structure.md)
Organização completa do projeto, descrição de cada diretório e convenções de nomenclatura.

**Tópicos:**
- Estrutura de Diretórios
- Organização da Camada de Apresentação
- Organização da Camada de Dados
- Organização da Camada de Domínio

---

## 🎯 Funcionalidades (Features)

### [🔐 Autenticação](./features/authentication.md)
Sistema completo de autenticação com Firebase Auth.

**Funcionalidades:**
- Login com email/senha
- Registro de nova conta
- Recuperação de senha
- Logout
- Persistência de sessão

### [💰 CRUD de Transações](./features/transactions_crud.md)
Gerenciamento completo de receitas e despesas.

**Funcionalidades:**
- Criar transação
- Editar transação
- Excluir transação
- Listar transações
- Filtros avançados
- Busca e ordenação

### [📊 Dashboard e Analytics](./features/dashboard_analytics.md)
Visualização de métricas financeiras e gráficos interativos.

**Funcionalidades:**
- Saldo em tempo real
- Gráfico de pizza (categorias)
- Gráfico de barras (receitas vs despesas)
- Gráfico de linhas (evolução do saldo)
- Cards informativos

### [📄 Relatórios e Exportação](./features/reports_export.md)
Sistema de geração e compartilhamento de relatórios financeiros.

**Funcionalidades:**
- Exportação para Excel
- Exportação para CSV
- Exportação para PDF
- Compartilhamento via WhatsApp/Email
- Relatórios customizáveis

### [🔔 Notificações](./features/notifications.md)
Sistema de notificações push para engajamento do usuário.

**Funcionalidades:**
- Lembretes diários
- Alertas de limite de categoria
- Resumo mensal
- Notificações de metas

### [🔄 Sincronização](./features/synchronization.md)
Estratégia de sincronização bidirecional entre local e remoto.

**Funcionalidades:**
- Sincronização automática
- Resolução de conflitos (Last-Write-Wins)
- Soft-Deletes
- Sincronização manual

---

## 🛠️ Recursos Técnicos

### Tecnologias Principais
- **Flutter:** 3.38
- **Dart:** 3.10
- **Gerenciamento de Estado:** Riverpod
- **Banco Local:** Drift (SQLite)
- **Backend:** Firebase (Auth + Firestore)
- **Gráficos:** fl_chart
- **UI Framework:** flutter_neumorphic_plus

### Padrões de Qualidade
- ✅ Arquitetura MVVM
- ✅ Clean Code
- ✅ SOLID Principles
- ✅ Testes (Unit, Widget, Integration)
- ✅ Cobertura mínima: 80%
- ✅ Linting rigoroso

### Design System
- 🎨 Tema Neumorphic
- 🌍 Localização: PT-PT
- 💶 Moeda: EUR
- 📱 Responsivo (Mobile, Tablet, Web)
- ✨ Animações fluidas (500ms)

---

## 📞 Contato e Suporte

**Desenvolvedor:** Leankar.dev  
**Email:** leankar.dev@gmail.com  
**Website:** https://leankar.dev  
**Versão:** 1.0.0  

---

## 📝 Notas de Desenvolvimento

- Todas as classes, funções e variáveis estão em **inglês**
- Interface do usuário (UI) está em **português de Portugal**
- Formato de data: **dd/MM/yyyy**
- Formato de moeda: **EUR (€)**
- Validações rigorosas em todos os formulários
- Feedback visual com SnackBars customizadas

---

**Última atualização:** Novembro 2025