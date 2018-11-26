echo "## Starting build of Mazi image."
echo "## If 'docker compose' isn't installed, packages won't be cached"
docker-compose up -d
IMG_NAME=mazi DEPLOY_DIR="$BASE_DIR/mazi-image" PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh
