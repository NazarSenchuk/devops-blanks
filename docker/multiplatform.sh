docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
echo "example: docker buildx build --platform linux/amd64,linux/arm64 -t username/myapp:latest --push ."