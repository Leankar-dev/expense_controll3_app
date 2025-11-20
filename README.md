# 💰 Expense Control APP

## 📱 Sobre o Projeto

**Expense Control APP** é um aplicativo de controle financeiro pessoal desenvolvido em Flutter, seguindo os mais altos padrões de qualidade, arquitetura MVVM e foco em performance e UX/UI.

O aplicativo permite gerir receitas e despesas com sincronização na nuvem, relatórios detalhados, gráficos interativos e notificações inteligentes.

### 🌍 Localização
- **Idioma da Interface:** Português (Portugal)
- **Moeda:** EUR (€)
- **Formato de Data:** dd/MM/yyyy

---

## ✨ Funcionalidades

### 💳 Gestão de Transações
- ✅ CRUD completo de transações (receitas e despesas)
- ✅ Categorização personalizada
- ✅ Múltiplos métodos de pagamento (Cartão Crédito, Débito, MBWay, PIX, Dinheiro)
- ✅ Filtros avançados por categoria, período e tipo
- ✅ Ordenação por data, valor ou categoria
- ✅ Busca por descrição, categoria ou valor

### 📊 Dashboard e Analytics
- ✅ Saldo atual em tempo real
- ✅ Totalizadores de receitas e despesas
- ✅ Gráfico de pizza (distribuição por categoria)
- ✅ Gráfico de barras (receitas vs despesas)
- ✅ Gráfico de linhas (evolução do saldo)
- ✅ Saldo acumulado histórico

### 🔐 Autenticação
- ✅ Login com email/senha
- ✅ Registo de nova conta
- ✅ Recuperação de senha por email
- ✅ Persistência de sessão

### 📄 Relatórios e Exportação
- ✅ Exportação para Excel (.xlsx)
- ✅ Exportação para CSV
- ✅ Exportação para PDF
- ✅ Partilha via WhatsApp e Email
- ✅ Relatórios mensais e anuais

### 🔔 Notificações
- ✅ Lembretes diários para registar gastos
- ✅ Alertas de limite de categoria excedido
- ✅ Resumo mensal automático

### 🔄 Sincronização
- ✅ Estratégia Offline-First
- ✅ Sincronização automática com Firebase
- ✅ Resolução de conflitos (Last-Write-Wins)

---

## 🛠 Tecnologias

### Core
| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| Flutter | 3.38+ | Framework UI |
| Dart | 3.10+ | Linguagem de programação |

### State Management & DI
| Pacote | Versão |
|--------|--------|
| flutter_riverpod | ^3.0.3 |
| riverpod_annotation | ^3.0.3 |
| riverpod_generator | ^3.0.1 |

### Database & Backend
| Pacote | Versão | Uso |
|--------|--------|-----|
| drift | ^2.29.0 | SQLite local |
| firebase_core | ^4.2.1 | Firebase base |
| firebase_auth | ^6.1.2 | Autenticação |
| cloud_firestore | ^6.1.0 | Sincronização |

### UI/UX
| Pacote | Versão | Uso |
|--------|--------|-----|
| flutter_neumorphic_plus | ^3.5.0 | Design Neumorphic |
| fl_chart | ^1.1.1 | Gráficos |

### Utilitários
| Pacote | Versão | Uso |
|--------|--------|-----|
| uuid | ^4.5.2 | Geração de IDs |
| intl | ^0.20.2 | Formatação |
| dartz | ^0.10.1 | Functional programming |
| connectivity_plus | ^7.0.0 | Verificação de rede |

### Exportação & Partilha
| Pacote | Versão |
|--------|--------|
| syncfusion_flutter_xlsio | ^31.2.12 |
| csv | ^6.0.0 |
| pdf | ^3.11.3 |
| share_plus | ^12.0.1 |

### Notificações
| Pacote | Versão |
|--------|--------|
| flutter_local_notifications | ^19.5.0 |
| timezone | ^0.10.1 |

---

## 📦 Instalação

### Pré-requisitos

- Flutter SDK 3.38+
- Dart SDK 3.10+
- Android Studio / VS Code
- Firebase CLI (para configuração do Firebase)

### Passos

1. **Clone o repositório**
```bash
git clone https://github.com/leankar/expense_controll3_app.git
cd expense_controll_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Configure o Firebase**
```bash
# Instale o Firebase CLI
npm install -g firebase-tools

# Login no Firebase
firebase login

# Configure o FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Gere os arquivos de código**
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. **Execute o aplicativo**
```bash
flutter run
```

---

## 🏗 Arquitetura

O projeto segue a arquitetura **MVVM** com princípios de **Clean Architecture**:

```
lib/
├── core/                    # Configurações e utilitários
│   ├── config/              # Rotas, constantes
│   ├── theme/               # Temas, cores, estilos
│   ├── exceptions/          # Exceções customizadas
│   ├── utils/               # Validadores, formatadores
│   └── widgets/             # Widgets reutilizáveis
│
├── data/                    # Camada de Dados
│   ├── models/              # Modelos de dados
│   ├── enums/               # Enumerações
│   ├── local/               # Drift (SQLite)
│   ├── remote/              # Firebase
│   └── repositories/        # Implementação de repositórios
│
├── domain/                  # Camada de Domínio
│   ├── entities/            # Entidades de negócio
│   └── usecases/            # Casos de uso
│
├── presentation/            # Camada de Apresentação
│   ├── providers/           # Providers Riverpod
│   ├── viewmodels/          # ViewModels
│   ├── views/               # Telas
│   └── animations/          # Animações
│
└── services/                # Serviços auxiliares
```

### Fluxo de Dados

```
View → ViewModel → UseCase → Repository → DAO/Firebase
  ↑                                            │
  └────────────── State Update ────────────────┘
```

---

## 🧪 Testes

### Executar todos os testes
```bash
flutter test
```

### Executar com cobertura
```bash
flutter test --coverage
```

### Gerar relatório de cobertura
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Meta de Cobertura
- **Mínimo:** 80%

---

## 📁 Estrutura de Diretórios

```
expense_controll_app/
├── DOCS/                    # Documentação
│   ├── index.md
│   ├── architecture.md
│   ├── backend.md
│   ├── structure.md
│   └── features/
├── lib/                     # Código-fonte
├── test/                    # Testes
├── android/                 # Configuração Android
├── ios/                     # Configuração iOS
├── assets/                  # Recursos estáticos
└── pubspec.yaml             # Dependências
```

---

## 📖 Documentação

A documentação completa está disponível na pasta `DOCS/`:

| Documento | Descrição |
|-----------|-----------|
| [index.md](DOCS/index.md) | Índice da documentação |
| [architecture.md](DOCS/architecture.md) | Arquitetura MVVM e Riverpod 3.x |
| [backend.md](DOCS/backend.md) | Drift 2.29 e Firebase 6.x |
| [structure.md](DOCS/structure.md) | Estrutura de pastas |
| [features/](DOCS/features/) | Documentação de funcionalidades |

---

## 🎨 Design System

### Tema
- **Estilo:** Neumorphic moderno
- **Responsividade:** Mobile-first (320px+), tablets, web

### Animações
- Transições de rota: 500ms
- Fade-in animations
- Hero animations em cards
- Shimmer loading

### Widgets Customizados
- `CustomNeumorphicButton`
- `NeumorphicTextFormField`
- `CustomSnackBar`
- `CustomAppBar`
- `ExpenseCard`
- `LoadingShimmer`

---

## 🔧 Configuração Android

### Requisitos Mínimos
- **minSdk:** 21 (Android 5.0+)
- **targetSdk:** 34
- **Gradle:** 8.14
- **AGP:** 8.11.1
- **Kotlin:** 2.2.20

### Desugaring
O projeto utiliza core library desugaring para compatibilidade com APIs Java 8+:

```kotlin
// android/app/build.gradle.kts
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

---

## 📱 Categorias Padrão

| Categoria | Ícone |
|-----------|-------|
| Alimentação | 🍔 |
| Transporte | 🚗 |
| Saúde | 💊 |
| Lazer | 🎮 |
| Outros | 📦 |

---

## 🔐 Métodos de Pagamento

- 💳 Cartão de Crédito
- 💳 Cartão de Débito
- 📱 MBWay
- 📱 PIX
- 💵 Dinheiro

---

## 📞 Suporte

Para suporte, entre em contacto através de:

- 📧 **Email:** leankar.dev@gmail.com
- 🌐 **Website:** [https://leankar.dev](https://leankar.dev)

---

## 👨‍💻 Desenvolvedor

<p align="center">
  <strong>Desenvolvido com ❤️ por Leankar.dev</strong>
</p>

<p align="center">
  <a href="https://leankar.dev">Website</a> •
  <a href="mailto:leankar.dev@gmail.com">Email</a>
</p>

---

## 📄 Licença

Este projeto é privado e de uso exclusivo.

---

## 📌 Versão

**Versão Atual:** 1.0.0

---

<p align="center">
  <sub>© 2025 Leankar.dev - Todos os direitos reservados</sub>
</p>