# GraphDB + Ontotext Refine - Configuração Docker

Um ambiente de desenvolvimento para trabalhar com dados semânticos usando GraphDB e Ontotext Refine, containerizado com Docker para configuração e implantação fáceis.

[🇺🇸 Read in English](./README.md)

## Visão Geral

Este projeto fornece um ambiente Docker pré-configurado com:
- **GraphDB 11.1.0** - Banco de dados RDF de nível empresarial com raciocínio semântico
- **Ontotext Refine 1.2.2** - Ferramenta de transformação e limpeza de dados para dados semânticos

Ambos os serviços são configurados para trabalhar juntos perfeitamente, facilitando a configuração de um fluxo de trabalho completo para gerenciamento de dados semânticos.

## Pré-requisitos

Antes de executar este projeto, certifique-se de ter o seguinte instalado:

- **[Docker](https://www.docker.com/)** - Plataforma de containers
- **[Docker Compose](https://docs.docker.com/compose/)** - Aplicações Docker multi-container

## Início Rápido

### Opção 1: Usando Git (recomendado)

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/patrezze/graphdb-refine-stack.git
   cd graphdb-refine-stack
   ```

### Opção 2: Download sem Git

1. **Baixe o projeto:**
   - Clique no botão verde "Code" no [GitHub](https://github.com/patrezze/graphdb-refine-stack)
   - Selecione "Download ZIP"
   - Extraia o arquivo ZIP para o local desejado
   - Abra um terminal/prompt de comando na pasta extraída

2. **Inicie os serviços:**
   ```bash
   docker compose up -d
   ```

3. **Acesse os serviços:**
   - **GraphDB**: http://localhost:7200/
   - **Ontotext Refine**: http://localhost:7333/

## Informações dos Serviços

| Serviço | Porta | Descrição | URL de Acesso |
|---------|-------|-----------|---------------|
| GraphDB | 7200 | Banco de dados RDF com raciocínio semântico | http://localhost:7200/ |
| Ontotext Refine | 7333 | Ferramenta de transformação e limpeza de dados | http://localhost:7333/ |

## Configuração de Licença

### Licença GraphDB

O GraphDB requer uma licença para funcionar. Você pode obter uma licença gratuita seguindo estes passos:

1. **Solicite uma licença:**
   - Visite [Experimentar GraphDB](https://www.ontotext.com/products/graphdb/#try-graphdb)
   - Preencha o formulário para solicitar uma licença gratuita
   - A chave da licença será enviada para seu email

2. **Registre a licença:**
   - Acesse o GraphDB em http://localhost:7200/
   - Navegue para http://localhost:7200/license/register
   - Cole sua chave de licença e envie

### Tipos de Licença

Para informações sobre diferentes tipos de licença e seus recursos, visite:
[Documentação de Licenciamento GraphDB](https://graphdb.ontotext.com/documentation/11.1/licensing.html)

Para instruções detalhadas de configuração, veja:
[Guia de Configuração de Licença GraphDB](https://graphdb.ontotext.com/documentation/11.1/set-up-your-license.html)

## Estrutura do Projeto

```
graphdb-refine-stack/
├── docker-compose.yml   # Configuração dos serviços
├── README.md            # Versão em Inglês
└── README.pt.md         # Este arquivo (Português)
```

## Configuração Docker

Os serviços usam `network_mode: host` para rede simplificada, permitindo acesso direto via localhost sem mapeamento de portas.

### Volumes

- **Dados GraphDB**: Armazenamento persistente para repositórios e dados
- **Dados Refine**: Armazenamento persistente para projetos de transformação de dados

## Comandos Úteis

```bash
# Iniciar serviços
docker compose up -d

# Parar serviços
docker compose down

# Visualizar logs
docker compose logs graphdb
docker compose logs refine

# Reiniciar serviços
docker compose restart
```

## Referências

### Documentação
- [Documentação GraphDB](https://graphdb.ontotext.com/documentation)
- [Site OpenRefine](https://openrefine.org/)
- [Plataforma Ontotext Refine](https://platform.ontotext.com/ontorefine/)

### Imagens Docker
- [Repositório Docker GraphDB](https://hub.docker.com/r/ontotext/graphdb)
- [Repositório Docker Ontotext Refine](https://hub.docker.com/r/ontotext/refine)

## Contribuindo

Sinta-se à vontade para enviar issues, solicitações de funcionalidades ou pull requests para melhorar este projeto.

## Licença

Este projeto é open source e está disponível sob a [Licença MIT](LICENSE).