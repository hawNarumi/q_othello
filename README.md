# Othello Game

A web-based Othello (Reversi) game built with Ruby on Rails.

## System Requirements

* Ruby version: 3.4.4
* Rails version: 8.0.1
* Node.js (for asset compilation)

## Getting Started

### Option 1: Running with Docker (Recommended)

The easiest way to run this application is using Docker. This method doesn't require you to install Ruby or Rails on your local machine.

#### Prerequisites
- Docker
- Docker Compose

#### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd othello_game

# Build and start the application
docker compose up -d

# Access the application
open http://localhost:3000
```

#### Docker Commands
```bash
# Start the application in the background
docker compose up -d

# Start the application with logs visible
docker compose up

# Stop the application
docker compose down

# View logs
docker compose logs

# Follow logs in real-time
docker compose logs -f

# Rebuild the image (after code changes)
docker compose build

# Restart the application
docker compose restart
```

#### Docker Configuration
- **Base Image**: Ruby 3.4.4-slim
- **Port**: 3000 (mapped to host port 3000)
- **Environment**: Development
- **Volume**: No persistent volumes (stateless application)

### Option 2: Running Locally

If you prefer to run the application directly on your local machine:

#### Prerequisites
- Ruby 3.4.4
- Rails 8.0.1
- Bundler

#### Setup
```bash
# Install dependencies
bundle install

# Precompile assets
rails assets:precompile

# Start the server
rails server

# Access the application
open http://localhost:3000
```

## Application Features

* Web-based Othello/Reversi game
* Interactive game board
* Real-time game state updates
* Responsive design

## Development

### Making Changes

When developing with Docker:

1. Make your code changes
2. Rebuild the Docker image: `docker compose build`
3. Restart the container: `docker compose up -d`

### Debugging

To access the Rails console in the Docker container:
```bash
docker compose exec web rails console
```

To access the container shell:
```bash
docker compose exec web bash
```

## Project Structure

```
othello_game/
├── app/
│   ├── controllers/
│   ├── models/
│   ├── views/
│   └── assets/
├── config/
├── Dockerfile
├── docker-compose.yml
├── Gemfile
├── Gemfile.lock
└── README.md
```

## Deployment

### Docker Deployment

For production deployment, you can use the same Docker setup:

1. Set environment variables for production
2. Use a production-ready web server (already configured with Puma)
3. Deploy to your preferred container platform (AWS ECS, Google Cloud Run, etc.)

### Traditional Deployment

For traditional deployment without Docker:

1. Set up Ruby 3.4.4 and Rails 8.0.1 on your server
2. Install dependencies with `bundle install --deployment`
3. Precompile assets with `RAILS_ENV=production rails assets:precompile`
4. Start the application with `RAILS_ENV=production rails server`

## Troubleshooting

### Docker Issues

**Container won't start:**
- Check if port 3000 is already in use: `lsof -i :3000`
- View container logs: `docker compose logs`

**Application not accessible:**
- Ensure the container is running: `docker ps`
- Check port mapping: `docker compose ps`

**Build failures:**
- Clean Docker cache: `docker system prune -f`
- Rebuild from scratch: `docker compose build --no-cache`

### Local Development Issues

**Bundle install fails:**
- Ensure you have Ruby 3.4.4 installed
- Update bundler: `gem update bundler`

**Assets not loading:**
- Precompile assets: `rails assets:precompile`
- Clear cache: `rails tmp:clear`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker: `docker compose up`
5. Submit a pull request
