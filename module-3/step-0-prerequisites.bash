# Docker Tools (macOS Apple Silicon M1)

# brew install minikube
# brew install --cask docker
# brew install qemu
# minikube start --driver=qemu

# Second approach

# Use Colima to Run Docker Containers on macOS
# https://smallsharpsoftwaretools.com/tutorials/use-colima-to-run-docker-containers-on-macos/

brew install colima
brew install docker docker-compose

# Create a folder in the home directory to hold Docker CLI plugins:
mkdir -p ~/.docker/cli-plugins

# Symlink the docker-compose command into that folder
ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose

brew install docker-Buildx
ln -sfn $(brew --prefix)/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx

# be capable of running PetStoreApp, PetService, ProductService, and OrderService locally
# within IntelliJ IDEA and Docker as a unified application.
