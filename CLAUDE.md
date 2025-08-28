# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Spring Boot 3.5.5 web application built with Maven and Java 21, designed for CI/CD training purposes. The project uses a standard Spring Boot structure with minimal dependencies (Spring Web, Lombok) and follows Maven conventions.

## Build and Development Commands

### Building the application
```bash
# Clean and compile
./mvnw clean compile

# Package the application
./mvnw clean package

# Run the application
./mvnw spring-boot:run
```

### Running tests
```bash
# Run all tests
./mvnw test

# Run specific test class
./mvnw test -Dtest=CicdtrainingApplicationTests
```

### Development workflow
```bash
# Start the application in development mode (auto-restart on changes)
./mvnw spring-boot:run

# Access the application at http://localhost:8080
```

## Project Structure

- **Main application**: `src/main/java/be/aboutcoding/cicdtraining/CicdtrainingApplication.java` - Standard Spring Boot entry point
- **Configuration**: `src/main/resources/application.properties` - Basic Spring configuration
- **Package structure**: `be.aboutcoding.cicdtraining` - Root package for all Java classes
- **Maven configuration**: Uses Spring Boot parent POM with minimal web dependencies

## Key Technologies

- **Spring Boot 3.5.5**: Main framework
- **Java 21**: Target Java version
- **Maven**: Build tool with wrapper included
- **Lombok**: Code generation for boilerplate reduction
- **JUnit 5**: Testing framework (via spring-boot-starter-test)

## Development Notes

- The project includes Maven wrapper (`mvnw`/`mvnw.cmd`) so no local Maven installation is required
- Lombok annotation processing is configured in the Maven compiler plugin
- Default Spring Boot test slice available for context loading verification
- never run git commands automatically, not even when asked
- never do database operations automatically,not even when asked