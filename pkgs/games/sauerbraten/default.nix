{ stdenv, fetchsvn, libGLU_combined, SDL, SDL_image, SDL_mixer
, libpng, zlib, libjpeg, imagemagick, libX11
}:

stdenv.mkDerivation rec {
  name = "sauerbraten-r${version}";
  version = "5000";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/sauerbraten/code";
    sha256 = "17libj7dslprlwppdk3vyxdcigbsa4czln8gdyz9j264m11z1cbh";
    rev = version;
  };

  buildInputs = [
    libGLU_combined SDL SDL_image SDL_mixer libpng zlib libjpeg imagemagick
    libX11
  ];

  preBuild = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11"
    pushd src
  '';

  installPhase = ''
    popd
    mkdir -p $out/bin $out/share/sauerbraten $out/share/doc/sauerbraten
    cp -rv "docs/"* $out/share/doc/sauerbraten/
    cp -v src/sauer_client src/sauer_server $out/share/sauerbraten/
    cp -rv packages $out/share/sauerbraten/
    cp -rv data $out/share/sauerbraten/
    cat > $out/bin/sauerbraten_server <<EOF
    #!${stdenv.shell}
    cd $out/share/sauerbraten
    ./sauer_server "\$@"
    EOF
    cat > $out/bin/sauerbraten_client <<EOF
    #!${stdenv.shell}
    cd $out/share/sauerbraten
    ./sauer_client "\$@"
    EOF
    chmod a+x $out/bin/sauerbraten_*
  '';

  meta = with stdenv.lib; {
    description = "";
    maintainers = [ maintainers.raskin ];
    hydraPlatforms =
      # raskin: tested amd64-linux;
      # not setting platforms because it is 0.5+ GiB of game data
      [];
    license = "freeware"; # as an aggregate - data files have different licenses
                          # code is under zlib license
    platforms = platforms.linux;
  };
}
