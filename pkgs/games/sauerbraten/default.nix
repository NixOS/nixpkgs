{ stdenv, fetchsvn, SDL2, SDL2_image, SDL2_mixer
, zlib, runtimeShell
}:

stdenv.mkDerivation rec {
  name = "sauerbraten-r${version}";
  version = "5492";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/sauerbraten/code";
    sha256 = "0pin7ggy84fadjvran18db5v0l81qfv42faknpfaxx47xqz00l5s";
    rev = version;
  };

  buildInputs = [
    SDL2 SDL2_mixer SDL2_image
    zlib
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
    #!${runtimeShell}
    cd $out/share/sauerbraten
    ./sauer_server "\$@"
    EOF
    cat > $out/bin/sauerbraten_client <<EOF
    #!${runtimeShell}
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
