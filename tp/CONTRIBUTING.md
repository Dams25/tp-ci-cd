# 🤝 Contributing to TodoList Production

Thank you for your interest in contributing to this project! Here's how to get started.

## 🚀 Quick Start for Contributors

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/todolist-production.git
   cd todolist-production
   ```
3. **Install dependencies**:
   ```bash
   chmod +x scripts/install.sh
   ./scripts/install.sh
   ```

## 🔄 Development Workflow

### 1. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Development Environment
```bash
# Start development environment
make dev

# Run tests continuously
make test

# Check code quality
make lint
```

### 3. Make Your Changes
- Follow existing code style and patterns
- Add tests for new functionality
- Update documentation if needed
- Ensure all existing tests pass

### 4. Test Your Changes
```bash
# Run all tests
make test

# Run integration tests
make test:integration

# Check health
make healthcheck
```

### 5. Commit Your Changes
```bash
git add .
git commit -m "feat: add your feature description"
```

We follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `style:` for code style changes
- `refactor:` for code refactoring
- `test:` for test additions/changes
- `chore:` for maintenance tasks

### 6. Push and Create PR
```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## 📋 Code Standards

### JavaScript/Node.js
- Use ES6+ features
- Follow ESLint configuration
- Write descriptive variable names
- Add JSDoc comments for functions

### Docker
- Use multi-stage builds
- Optimize layer caching
- Include security best practices
- Add health checks

### Documentation
- Update README if needed
- Add inline comments for complex logic
- Include examples in docs

## 🧪 Testing Guidelines

### Unit Tests
- Test individual functions/methods
- Mock external dependencies
- Aim for high coverage

### Integration Tests
- Test API endpoints
- Test database interactions
- Test Docker containers

### Health Checks
- Verify application startup
- Test external service connections
- Validate configuration

## 🐛 Bug Reports

Please include:
- **Environment details** (OS, Docker version, Node.js version)
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Logs/screenshots** if applicable

## ✨ Feature Requests

Please include:
- **Problem description**
- **Proposed solution**
- **Use case examples**
- **Implementation considerations**

## 📚 Resources

- [Project Architecture](docs/ARCHITECTURE.md)
- [Development Setup](docs/DEVELOPMENT.md)
- [Docker Documentation](deployment/docker/README.md)
- [API Documentation](docs/API.md)

## 🙏 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- CONTRIBUTORS.md file

## 📞 Questions?

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and ideas
- **Email**: [your-email@example.com]

Thank you for contributing! 🎉
