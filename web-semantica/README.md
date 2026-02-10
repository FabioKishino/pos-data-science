# GraphDB + Ontotext Refine Docker Setup

A development environment for working with semantic data using GraphDB and Ontotext Refine, containerized with Docker for easy setup and deployment.

[🇧🇷 Ler em Português](./README.pt.md)

## Overview

This project provides a pre-configured Docker environment with:
- **GraphDB 11.1.0** - Enterprise-grade RDF database with semantic reasoning
- **Ontotext Refine 1.2.2** - Data transformation and cleaning tool for semantic data

Both services are configured to work together seamlessly, making it easy to set up a complete semantic data management workflow.

## Prerequisites

Before running this project, ensure you have the following installed:

- **[Docker](https://www.docker.com/)** - Container platform
- **[Docker Compose](https://docs.docker.com/compose/)** - Multi-container Docker applications

## Quick Start

### Option 1: Using Git (recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/patrezze/graphdb-refine-stack.git
   cd graphdb-refine-stack
   ```

### Option 2: Download without Git

1. **Download the project:**
   - Click the green "Code" button on [GitHub](https://github.com/patrezze/graphdb-refine-stack)
   - Select "Download ZIP"
   - Extract the ZIP file to your desired location
   - Open a terminal/command prompt in the extracted folder

2. **Start the services:**
   ```bash
   docker compose up -d
   ```

3. **Access the services:**
   - **GraphDB**: http://localhost:7200/
   - **Ontotext Refine**: http://localhost:7333/

## Service Information

| Service | Port | Description | Access URL |
|---------|------|-------------|------------|
| GraphDB | 7200 | RDF database with semantic reasoning | http://localhost:7200/ |
| Ontotext Refine | 7333 | Data transformation and cleaning tool | http://localhost:7333/ |

## License Configuration

### GraphDB License

GraphDB requires a license to run. You can obtain a free license by following these steps:

1. **Request a license:**
   - Visit [Try GraphDB](https://www.ontotext.com/products/graphdb/#try-graphdb)
   - Fill out the form to request a free license
   - The license key will be sent to your email

2. **Register the license:**
   - Access GraphDB at http://localhost:7200/
   - Navigate to http://localhost:7200/license/register
   - Paste your license key and submit

### License Types

For information about different license types and their features, visit:
[GraphDB Licensing Documentation](https://graphdb.ontotext.com/documentation/11.1/licensing.html)

For detailed setup instructions, see:
[GraphDB License Setup Guide](https://graphdb.ontotext.com/documentation/11.1/set-up-your-license.html)

## Project Structure

```
graphdb-refine-stack/
├── docker-compose.yml   # Service configuration
├── README.md            # This file (English)
└── README.pt.md         # Portuguese version
```

## Docker Configuration

The services use `network_mode: host` for simplified networking, allowing direct localhost access without port mapping.

### Volumes

- **GraphDB data**: Persistent storage for repositories and data
- **Refine data**: Persistent storage for data transformation projects

## Useful Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs graphdb
docker compose logs refine

# Restart services
docker compose restart
```

## References

### Documentation
- [GraphDB Documentation](https://graphdb.ontotext.com/documentation)
- [OpenRefine Site](https://openrefine.org/)
- [Ontotext Refine Platform](https://platform.ontotext.com/ontorefine/)

### Docker Images
- [GraphDB Docker Repository](https://hub.docker.com/r/ontotext/graphdb)
- [Ontotext Refine Docker Repository](https://hub.docker.com/r/ontotext/refine)

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this project.

## License

This project is open source and available under the [MIT License](LICENSE).