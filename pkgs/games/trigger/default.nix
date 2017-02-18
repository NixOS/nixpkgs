{ fetchurl, stdenv, SDL2, freealut, SDL2_image, openal, physfs, zlib, mesa, glew }:

stdenv.mkDerivation rec {
  name = "trigger-rally-0.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/trigger-rally/${name}.tar.gz";
    sha256 = "095s4sx0s1ijlarkh84rvzlv4nxh9llrsal1lb3m3pf0v228gnzj";
  };

  buildInputs = [ SDL2 freealut SDL2_image openal physfs zlib mesa glew ];

  preConfigure = ''
    sed s,/usr/local,$out, -i bin/*defs

    cd src
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${SDL2.dev}/include/SDL2"
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

  meta = {
    description = "Rally";
    homepage = http://trigger-rally.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
