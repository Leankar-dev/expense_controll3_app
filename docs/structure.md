# 📁 Estrutura de Diretórios - Expense Control APP

## Visão Geral

O projeto segue uma estrutura modular baseada em **Clean Architecture** e **MVVM**, com clara separação de responsabilidades entre camadas.

---

## Estrutura Completa

```
expense_controll_app/
│
├── DOCS/                              # 📚 Documentação completa
│   ├── index.md                       # Índice principal
│   ├── architecture.md                # Arquitetura MVVM
│   ├── backend.md                     # Persistência e Firebase
│   ├── structure.md                   # Este arquivo
│   └── features/                      # Documentação de features
│       ├── authentication.md
│       ├── transactions_crud.md
│       ├── dashboard_analytics.md
│       ├── reports_export.md
│       ├── notifications.md
│       └── synchronization.md
│
├── lib/                               # 📱 Código-fonte principal
│   ├── main.dart                      # Entry point
│   │
│   ├── core/                          # 🔧 Configurações e utilitários
│   │   ├── config/
│   │   │   ├── app_routes.dart        # Rotas nomeadas       -  ok
│   │   │   └── app_constants.dart     # Constantes globais   -  ok
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart         # Tema Neumorphic  - ok
│   │   │   ├── app_colors.dart        # Paleta de cores  - ok
│   │   │   └── text_styles.dart       # Estilos de texto - ok
│   │   │
│   │   ├── exceptions/
│   │   │   └── base_exception.dart    # Exceções customizadas - ok
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart        # Validadores de form  -  ok
│   │   │   ├── formatters.dart        # Formatação de dados  -  ok
│   │   │   ├── date_helper.dart       # Utilitários de data  -  ok
│   │   │   └── currency_helper.dart   # Formatação de moeda  -  ok
│   │   │
│   │   └── widgets/                   # Widgets reutilizáveis
│   │       ├── custom_neumorphic_button.dart       -  ok
│   │       ├── neumorphic_text_form_field.dart     -  ok
│   │       ├── custom_snackbar.dart                -  ok
│   │       ├── custom_app_bar.dart                 -  ok
│   │       ├── expense_card.dart                   -  ok
│   │       ├── loading_shimmer.dart                -  ok
│   │       └── hero_dialog.dart                    -  ok
│   │
│   ├── data/                          # 💾 Camada de Dados
│   │   ├── models/
│   │   │   ├── transaction_model.dart      
│   │   │   ├── category_model.dart
│   │   │   ├── user_model.dart
│   │   │   └── sync_metadata_model.dart
│   │   │
│   │   ├── enums/
│   │   │   ├── transaction_type.dart  # Income/Expense         -  ok
│   │   │   └── payment_method.dart    # Cartão, MBWay, etc.    -  ok
│   │   │
│   │   ├── local/                     # Persistência local (Drift)
│   │   │   ├── database/
│   │   │   │   ├── app_database.dart  # Configuração Drift
│   │   │   │   ├── app_database.g.dart
│   │   │   │   └── tables/
│   │   │   │       ├── transactions_table.dart
│   │   │   │       ├── categories_table.dart
│   │   │   │       └── sync_metadata_table.dart
│   │   │   │
│   │   │   └── dao/                   # Data Access Objects
│   │   │       ├── transaction_dao.dart
│   │   │       ├── category_dao.dart
│   │   │       └── sync_metadata_dao.dart
│   │   │
│   │   ├── remote/                    # Acesso remoto (Firebase)
│   │   │   └── firebase/
│   │   │       ├── firebase_auth_service.dart
│   │   │       ├── firebase_sync_service.dart
│   │   │       └── firebase_storage_service.dart
│   │   │
│   │   └── repositories/              # Implementação de repositórios
│   │       ├── transaction_repository.dart
│   │       ├── category_repository.dart
│   │       ├── auth_repository.dart
│   │       └── sync_repository.dart
│   │
│   ├── domain/                        # 🎯 Camada de Domínio
│   │   ├── entities/
│   │   │   ├── transaction_entity.dart
│   │   │   ├── category_entity.dart
│   │   │   └── user_entity.dart
│   │   │
│   │   └── usecases/                  # Casos de uso
│   │       ├── transaction/
│   │       │   ├── create_transaction_usecase.dart
│   │       │   ├── update_transaction_usecase.dart
│   │       │   ├── delete_transaction_usecase.dart
│   │       │   ├── get_transactions_usecase.dart
│   │       │   └── filter_transactions_usecase.dart
│   │       │
│   │       ├── category/
│   │       │   ├── create_category_usecase.dart
│   │       │   ├── update_category_usecase.dart
│   │       │   └── get_categories_usecase.dart
│   │       │
│   │       ├── auth/
│   │       │   ├── login_usecase.dart
│   │       │   ├── register_usecase.dart
│   │       │   ├── logout_usecase.dart
│   │       │   └── reset_password_usecase.dart
│   │       │
│   │       ├── analytics/
│   │       │   ├── calculate_balance_usecase.dart
│   │       │   ├── get_category_distribution_usecase.dart
│   │       │   └── get_balance_evolution_usecase.dart
│   │       │
│   │       └── export/
│   │           ├── export_to_excel_usecase.dart
│   │           ├── export_to_csv_usecase.dart
│   │           ├── export_to_pdf_usecase.dart
│   │           └── share_report_usecase.dart
│   │
│   ├── presentation/                  # 🎨 Camada de Apresentação
│   │   ├── providers/                 # Providers Riverpod
│   │   │   ├── auth_provider.dart
│   │   │   ├── transaction_provider.dart
│   │   │   ├── category_provider.dart
│   │   │   ├── dashboard_provider.dart
│   │   │   ├── filter_provider.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   ├── viewmodels/                # ViewModels (StateNotifier)
│   │   │   ├── auth_viewmodel.dart
│   │   │   ├── transaction_viewmodel.dart
│   │   │   ├── category_viewmodel.dart
│   │   │   ├── dashboard_viewmodel.dart
│   │   │   └── export_viewmodel.dart
│   │   │
│   │   ├── views/                     # Telas do app
│   │   │   ├── splash/
│   │   │   │   └── splash_screen.dart
│   │   │   │
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   │   └── forgot_password_screen.dart
│   │   │   │
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   │
│   │   │   ├── dashboard/
│   │   │   │   ├── dashboard_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── balance_card.dart
│   │   │   │       ├── pie_chart_widget.dart
│   │   │   │       ├── bar_chart_widget.dart
│   │   │   │       └── line_chart_widget.dart
│   │   │   │
│   │   │   ├── transactions/
│   │   │   │   ├── transactions_list_screen.dart
│   │   │   │   ├── transaction_form_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── transaction_list_item.dart
│   │   │   │       └── filter_bottom_sheet.dart
│   │   │   │
│   │   │   ├── categories/
│   │   │   │   ├── categories_screen.dart
│   │   │   │   └── category_form_screen.dart
│   │   │   │
│   │   │   ├── reports/
│   │   │   │   ├── reports_screen.dart
│   │   │   │   └── report_preview_screen.dart
│   │   │   │
│   │   │   └── settings/
│   │   │       └── settings_screen.dart
│   │   │
│   │   └── animations/                # Animações customizadas
│   │       ├── slide_route_transition.dart
│   │       └── hero_dialog_route.dart
│   │
│   └── services/                      # 🔧 Serviços auxiliares
│       ├── notification_service.dart  # Push notifications
│       ├── export_service.dart        # Exportação de arquivos
│       └── share_service.dart         # Compartilhamento nativo
│
├── test/                              # 🧪 Testes
│   ├── unit/                          # Testes unitários
│   │   ├── usecases/
│   │   ├── repositories/
│   │   └── utils/
│   │
│   ├── widget/                        # Testes de widget
│   │   └── presentation/
│   │
│   └── integration/                   # Testes de integração
│       └── flows/
│
├── assets/                            # 🖼️ Recursos estáticos
│   ├── images/
│   │   └── logo.png
│   │
│   └── fonts/
│       └── (fontes customizadas)
│
├── android/                           # 📱 Configuração Android
├── ios/                               # 🍎 Configuração iOS
├── web/                               # 🌐 Configuração Web
│
├── pubspec.yaml                       # 📦 Dependências
├── analysis_options.yaml              # 🔍 Regras de lint
├── README.md                          # 📖 Documentação inicial
└── .gitignore                         # 🚫 Arquivos ignorados

```

---

## Descrição das Camadas

### 🔧 **core/**
Contém toda a infraestrutura compartilhada:
- **config/**: Rotas e constantes
- **theme/**: Temas e estilos visuais
- **exceptions/**: Tratamento de erros customizados
- **utils/**: Funções auxiliares
- **widgets/**: Componentes reutilizáveis

### 💾 **data/**
Implementação da camada de dados:
- **models/**: Representação de dados (JSON/Database)
- **enums/**: Tipos enumerados
- **local/**: Drift (SQLite)
- **remote/**: Firebase
- **repositories/**: Implementação de repositórios

### 🎯 **domain/**
Lógica de negócio pura:
- **entities/**: Objetos de negócio
- **usecases/**: Casos de uso específicos (regras de negócio)

### 🎨 **presentation/**
Interface com o usuário:
- **providers/**: Definição de providers Riverpod
- **viewmodels/**: Lógica de apresentação (StateNotifier)
- **views/**: Telas e widgets
- **animations/**: Animações customizadas

### 🔧 **services/**
Serviços de terceiros ou funcionalidades específicas do sistema.

---

## Convenções de Nomenclatura

### Arquivos
- **snake_case**: `transaction_repository.dart`
- Sufixos descritivos: `_screen.dart`, `_widget.dart`, `_provider.dart`

### Classes
- **PascalCase**: `TransactionRepository`
- Sufixos: `Screen`, `Widget`, `Provider`, `ViewModel`, `UseCase`

### Variáveis e Funções
- **camelCase**: `createTransaction()`, `userName`

### Constantes
- **lowerCamelCase** ou **UPPER_SNAKE_CASE**: `defaultPadding` ou `MAX_RETRIES`

---

## Fluxo de Dados (MVVM)

```
View (UI)
    ↓ (user interaction)
ViewModel (StateNotifier)
    ↓ (calls)
UseCase (Business Logic)
    ↓ (calls)
Repository (Data Access)
    ↓ (calls)
DAO/Service (Database/API)
    ↓ (returns data)
Repository
    ↓ (returns Either<Failure, Success>)
UseCase
    ↓ (updates state)
ViewModel
    ↓ (notifies)
View (rebuild)
```

---

## Organização de Imports

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages externos
import 'package:riverpod/riverpod.dart';
import 'package:drift/drift.dart';

// 4. Imports internos (ordem alfabética)
import 'package:expense_controll_app/core/theme/app_colors.dart';
import 'package:expense_controll_app/data/models/transaction_model.dart';
import 'package:expense_controll_app/presentation/viewmodels/transaction_viewmodel.dart';
```

---

## Boas Práticas

### ✅ **1. Separação de Responsabilidades**
Cada arquivo tem uma única responsabilidade clara.

### ✅ **2. Modularidade**
Código organizado em módulos independentes e reutilizáveis.

### ✅ **3. Nomenclatura Consistente**
Seguir convenções de nomenclatura em todo o projeto.

### ✅ **4. Documentação Inline**
Comentários claros em lógicas complexas.

### ✅ **5. Testes Co-localizados**
Estrutura de testes espelha a estrutura de `lib/`.

---

**Desenvolvido por:** Leankar.dev  
**Versão:** 1.0.0  
**Contato:** leankar.dev@gmail.com  
**Website:** https://leankar.dev