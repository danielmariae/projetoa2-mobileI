# Sistema Acadêmico - Documentação

## 📌 Visão Geral

Este projeto consiste em um sistema acadêmico desenvolvido em Flutter para gerenciamento de informações estudantis, incluindo:

- Autenticação de alunos
- Visualização de boletim acadêmico
- Consulta de grade curricular
- Processo de rematrícula online
- Acompanhamento da situação acadêmica
- Análise de progresso no curso

## 🛠 Tecnologias Utilizadas

- **Flutter** (v3.0+)
- **Dart** (v2.17+)
- **HTTP** (para consumo de API REST)
- **MockAPI** (serviço mock para simulação de backend)

## 🔌 Endpoints da API

| Serviço      | Endpoint                                                  |
| ------------ | --------------------------------------------------------- |
| Autenticação | `https://684b8fb7ed2578be881bb6f8.mockapi.io/students`    |
| Disciplinas  | `https://684b8fb7ed2578be881bb6f8.mockapi.io/disciplines` |

## 🖥 Telas do Sistema

### 1. Login
- Autenticação por e-mail e senha
- Validação de campos
- Tratamento de erros

### 2. Dashboard
- Menu principal com acesso a todas funcionalidades
- Cards de navegação intuitivos

### 3. Boletim Acadêmico
- Listagem de disciplinas cursadas
- Visualização de notas parciais e finais
- Status de aprovação/reprovação

### 4. Grade Curricular
- Consulta por período acadêmico
- Detalhes de carga horária
- Progresso por disciplina

### 5. Rematrícula Online
- Seleção de disciplinas para novo período
- Confirmação de matrícula
- Validação de pré-requisitos

### 6. Situação Acadêmica
- Status atual do aluno
- Documentação pendente/entregue
- Situação de rematrícula

### 7. Análise Curricular
- Progresso geral no curso
- Percentual de conclusão
- Disciplinas concluídas e pendentes

## 🧩 Estrutura do Projeto

```
lib/
├── models/
│   ├── student.dart
│   ├── discipline.dart
│   ├── course.dart
│   ├── document.dart
│   └── reenrollment.dart
├── services/
│   ├── auth_service.dart
│   ├── student_service.dart
│   ├── discipline_service.dart
│   ├── course_service.dart
│   ├── document_service.dart
│   └── reenrollment_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   ├── boletim_screen.dart
│   ├── grade_screen.dart
│   ├── rematricula_screen.dart
│   ├── situacao_screen.dart
│   └── analise_screen.dart
└── main.dart
```

## ⚙️ Configuração do Ambiente

1. **Pré-requisitos**
   - Flutter SDK instalado
   - Dispositivo/emulador configurado
   - Android Studio/VSCode com plugins Flutter/Dart

2. **Instalação**
   ```bash
   flutter pub get
   flutter run
   ```

3. **Variáveis de Ambiente**
   - Configurar URLs da API no arquivo `.env`
   - Definir chaves de acesso quando necessário

## 🐛 Solução de Problemas Comuns

### Erro "Bad state: No element"
- Verifique se os IDs/matrículas correspondem aos dados da API
- Confira o tratamento de valores nulos nos models

### Dados não carregando
- Valide a conexão com a internet
- Verifique os endpoints no serviço correspondente
- Confira os logs do aplicativo

### Problemas de autenticação
- Confira os campos de e-mail e senha no JSON
- Valide o tratamento de erros no AuthService

## 📝 Licença

Este projeto está licenciado sob a MIT License.

## ✉️ Contato

Para dúvidas ou sugestões, entre em contato com [lucasdaniel@unitins.br]

---

**Nota:** Este projeto utiliza uma API mock para fins de desenvolvimento e teste. Para implementação em produção, substitua os endpoints mock por serviços reais.
