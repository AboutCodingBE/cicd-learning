# GitHub Actions Pipeline for Fly.io Deployment

> ** Important! **
> 
> You need to create the app on fly.io first. This is a bit silly for a deployment pipeline I think, but
> I ll see if I can do something about that. 

This guide shows how to set up a simple CI/CD pipeline using GitHub Actions to automatically deploy your application to Fly.io whenever you push to the main branch. Fly.io will build your Docker image from your Dockerfile.

## Why This Approach?

- ✅ **Simple setup** - minimal configuration required
- ✅ **Fast builds** - Fly.io's infrastructure is optimized for building
- ✅ **No registry management** - no need to manage Docker registries
- ✅ **Cost effective** - no additional registry storage costs
- ✅ **Automatic deployment** - deploy on every push to main

## Prerequisites

1. A Fly.io account and app already created
2. A `Dockerfile` in your project root
3. A `fly.toml` configuration file
4. GitHub repository with your code

## Step 1: Create the GitHub Actions Workflow

Create the file `.github/workflows/deploy.yml` in your repository:

```yaml
name: Deploy to Fly.io

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    name: Deploy app
    runs-on: ubuntu-latest
    
    # Only deploy on main branch pushes, not PRs
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Fly.io CLI
        uses: superfly/flyctl-actions/setup-flyctl@master
      
      - name: Deploy to Fly.io
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

## Step 2: Get Your Fly.io API Token

Generate an API token from your terminal:

```bash
# Login to Fly.io (if not already logged in)
flyctl auth login

# Generate an API token
flyctl auth token
```

Copy the generated token - you'll need it for GitHub secrets.

## Step 3: Add the API Token to GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Set the name as: `FLY_API_TOKEN`
5. Paste your Fly.io API token as the value
6. Click **Add secret**

## Step 4: Ensure Your Project Structure

Make sure your project has these files:

```
your-project/
├── Dockerfile
├── fly.toml
├── .github/
│   └── workflows/
│       └── deploy.yml
└── src/
    └── (your application code)
```

### Example Dockerfile for Java/Spring Boot:

```dockerfile
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

### Example fly.toml:

```toml
app = "your-app-name"
primary_region = "ams"

[build]
  # Fly.io will build from your Dockerfile

[env]
  ENVIRONMENT = "production"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

[[vm]]
  size = "shared-cpu-1x"
  memory = "256mb"
```

## Step 5: Test the Pipeline

1. Make a change to your code
2. Commit and push to the main branch:

```bash
git add .
git commit -m "Setup CI/CD pipeline"
git push origin main
```

3. Go to your GitHub repository → **Actions** tab
4. Watch the deployment workflow run
5. Check your Fly.io app once the workflow completes

## How It Works

1. **Trigger**: Workflow runs on every push to the main branch
2. **Build**: Fly.io reads your `Dockerfile` and builds the image remotely
3. **Deploy**: Fly.io deploys the new image to your app
4. **Rollback**: If deployment fails, Fly.io automatically rolls back

## Workflow Explanation

```yaml
# Triggers: Run on push to main, but also on PRs for validation
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# Conditional deployment: Only deploy actual pushes to main, not PRs
if: github.ref == 'refs/heads/main' && github.event_name == 'push'

# Remote build: --remote-only flag makes Fly.io build on their servers
run: flyctl deploy --remote-only
```

## Optional Enhancements

### Add Testing Before Deployment

```yaml
jobs:
  test:
    name: Run tests
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up JDK 21
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
      
      - name: Run tests
        run: ./mvnw test

  deploy:
    name: Deploy app
    runs-on: ubuntu-latest
    needs: test  # Wait for tests to pass
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      
      - name: Deploy to Fly.io
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

### Add Deployment Notifications

```yaml
      - name: Deploy to Fly.io
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
      
      - name: Notify deployment success
        if: success()
        run: echo "🚀 Deployment successful!"
      
      - name: Notify deployment failure
        if: failure()
        run: echo "❌ Deployment failed!"
```

## Troubleshooting

### Common Issues:

1. **"App not found"** - Make sure your `fly.toml` has the correct app name
2. **"Invalid API token"** - Regenerate your token and update GitHub secrets
3. **"Build failed"** - Check your Dockerfile syntax and build process

### Debug Commands:

```bash
# Check your app status
flyctl status --app your-app-name

# View deployment logs
flyctl logs --app your-app-name

# Check app configuration
flyctl config show --app your-app-name
```

## Security Notes

- ✅ **API token is secure** - stored as GitHub secret, not in code
- ✅ **Limited scope** - token only has access to your Fly.io apps
- ✅ **Revokable** - you can regenerate tokens anytime
- ✅ **Branch protection** - only deploys from main branch

## Next Steps

Once this basic pipeline is working, you can enhance it with:

- **Multi-environment deployments** (staging/production)
- **Database migrations**
- **Health checks**
- **Rollback strategies**
- **Slack/Discord notifications**

This simple pipeline gives you automatic deployments with minimal setup - perfect for getting started with CI/CD! 🚀


## Problems encountered: 

### Could not find app (by fly.io)
Fixed that by creating the app first on fly.io using a command. See the README warning about this. 

### Failed to fetch from source

```shell
> [2/2] COPY target/*.jar app.jar:
------
Error: failed to fetch an image or build from source: error building: failed to solve: lstat /tmp/buildkit-mount1157068294/target: no such file or directory
Error: Process completed with exit code 1.
```

If I choose to let fly.io build the docker file, I need set up the docker file differently. 
In the future, I might need to adjust the fly.toml file to take a docker image. That means getting it on a docker image
repository or artifact

Claude suggests the following change: 

```docker
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Copy Maven wrapper and pom.xml first (for better caching)
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Download dependencies (cached if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline

# Copy source code and build
COPY src/ src/
RUN ./mvnw clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built JAR from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```