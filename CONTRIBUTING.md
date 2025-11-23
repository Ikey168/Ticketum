# Contributing to Deskulo

Thank you for your interest in contributing to Deskulo! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists in the [Issues](https://github.com/Ikey168/Ticketum/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - SAP S/4HANA version
   - Any relevant error messages or logs

### Code Contributions

1. **Fork the Repository**
   - Fork the Deskulo repository to your GitHub account
   - Clone your fork locally

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
   
   Use branch naming conventions:
   - `feature/` for new features
   - `bugfix/` for bug fixes
   - `docs/` for documentation changes
   - `refactor/` for code refactoring

3. **Make Your Changes**
   - Follow the ABAP coding standards
   - Ensure your code follows SAP naming conventions
   - Use the prefix `ZDESK_` for all new objects
   - Add appropriate comments where necessary
   - Update documentation if needed

4. **Test Your Changes**
   - Test thoroughly in your SAP development system
   - Verify that existing functionality still works
   - Test edge cases and error scenarios
   - Ensure Fiori UI works as expected

5. **Run Code Quality Checks**
   - Use abaplint to check code quality
   - Fix any issues reported by the linter
   - Ensure code adheres to the abaplint.json configuration

6. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Brief description of changes"
   ```
   
   Commit message format:
   - Use present tense ("Add feature" not "Added feature")
   - Keep first line under 50 characters
   - Add detailed description if needed

7. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template with:
     - Description of changes
     - Related issue number (if applicable)
     - Testing performed
     - Screenshots (for UI changes)

## Coding Standards

### ABAP Guidelines

1. **Naming Conventions**
   - Tables: `ZDESK_*`
   - Interface Views: `ZI_DESK_*`
   - Consumption Views: `ZC_DESK_*`
   - Classes: `ZBP_I_DESK_*`, `ZCL_DESK_*`
   - Function Groups: `ZDESK_*`

2. **Code Style**
   - Use uppercase for ABAP keywords
   - Maximum line length: 120 characters
   - Use meaningful variable names
   - Add comments for complex logic
   - Follow SAP's Clean ABAP guidelines

3. **CDS Views**
   - Use camel case for element names
   - Add proper annotations
   - Include descriptions (@EndUserText.label)
   - Use associations appropriately

4. **Behavior Definitions**
   - Follow RAP best practices
   - Use managed implementation when possible
   - Implement proper validations
   - Add meaningful error messages

### Documentation

- Update README.md if adding major features
- Update DOCUMENTATION.md for detailed changes
- Add inline comments for complex logic
- Update CHANGELOG.md with your changes
- Include JSDoc-style comments for public methods

## Development Setup

1. **Prerequisites**
   - SAP S/4HANA system (2020 or later)
   - ABAP Development Tools (ADT)
   - abapGit plugin
   - Git client

2. **Setup Steps**
   - Clone the repository
   - Import into your SAP system via abapGit
   - Create a development package
   - Activate all objects

3. **Tools**
   - Use ABAP Development Tools in Eclipse
   - Install abaplint for local code checking
   - Use abapGit for version control

## Testing

### Unit Tests

- Write unit tests for new functionality
- Ensure all tests pass before submitting PR
- Aim for good code coverage

### Integration Tests

- Test the complete flow end-to-end
- Test via Fiori UI
- Test OData API endpoints
- Verify data persistence

### Manual Testing

- Test in SAP GUI
- Test in Fiori Launchpad
- Test with different user roles
- Test error scenarios

## Code Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Your contribution will be included in the next release

## Questions?

If you have questions:
- Open an issue with the "question" label
- Contact the maintainers
- Check existing documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions help make Deskulo better for everyone!
