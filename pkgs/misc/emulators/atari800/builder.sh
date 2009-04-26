source $stdenv/setup

preConfigure() {
    cd src
}

postInstall() {
    romsDir=$out/share/atari800/roms
    ensureDir $romsDir
    unzip $rom -d $romsDir
}

genericBuild
