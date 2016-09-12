{ fetchurl, stdenv, SDL, freealut, SDL_image, openal, physfs, zlib, mesa, glew }:

stdenv.mkDerivation rec {
  name = "trigger-rally-0.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}.tar.gz";
    sha256 = "103mv4vpq335mrmgzlhahrfncq7ds3b5ip5a52967rv2j6hhzpvy";
  };

  buildInputs = [ SDL freealut SDL_image openal physfs zlib mesa glew ];

  preConfigure = ''
    sed s,/usr/local,$out, -i bin/*defs

    cd src
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL.dev}/include/SDL"
    export makeFlags="$makeFlags prefix=$out"
  '';

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/trigger-rally
    #!/bin/sh
    exec $out/games/trigger-rally "$@"
    EOF
    chmod +x $out/bin/trigger-rally
  '';

  # search.patch :   fix c++ error.
  patches = [ ./search.patch ];

  meta = {
    description = "Rally";
    homepage = http://trigger-rally.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
