echo "## Starting clean build of Mazi image."
echo "## If 'docker compose' isn't installed, packages won't be cached"
docker rm -v pigen_work
docker-compose up -d
IMG_NAME=mazi DEPLOY_DIR="$BASE_DIR/mazi-image" ./build-docker.sh
