preConfigure=preConfigure
preConfigure() {
    unpackFile $mesaSrc
    configureFlags="$configureFlags --with-mesa-source=$(ls -d $(pwd)/Mesa-*)"
}