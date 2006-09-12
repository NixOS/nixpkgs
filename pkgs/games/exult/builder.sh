source $stdenv/setup

postInstall=postInstall
postInstall() {
    ensureDir $out/share/exult/music
    for i in $musicFiles; do
        unzip -o -d $out/share/exult/music $i
    done
}

genericBuild