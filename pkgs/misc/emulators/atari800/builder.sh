source $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    cd src
}

postInstall=postInstall
postInstall() {
    romsDir=$out/share/atari800/roms
    ensureDir $romsDir
    unzip $rom -d $romsDir
}

genericBuild
