{ stdenv, fetchurl, zlib, libjpeg, libpng, imake, gccmakedep }:

stdenv.mkDerivation rec {
  name = "transfig-3.2.4";
  src = fetchurl {
    url = ftp://ftp.tex.ac.uk/pub/archive/graphics/transfig/transfig.3.2.4.tar.gz;
    sha256 = "0429snhp5acbz61pvblwlrwv8nxr6gf12p37f9xxwrkqv4ir7dd4";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ zlib libjpeg libpng ];

  patches = [
    ./patch-fig2dev-dev-Imakefile
    ./patch-fig2dev-Imakefile
    ./patch-transfig-Imakefile
    ./patch-fig2dev-fig2dev.h
    ./patch-fig2dev-dev-gensvg.c
  ];

  patchPhase = ''
    runHook prePatch

    configureImakefiles() {
        local sedcmd=$1

        sed "$sedcmd" fig2dev/Imakefile > tmpsed
        cp tmpsed fig2dev/Imakefile

        sed "$sedcmd" fig2dev/dev/Imakefile > tmpsed
        cp tmpsed fig2dev/dev/Imakefile

        sed "$sedcmd" transfig/Imakefile > tmpsed
        cp tmpsed transfig/Imakefile
    }

    for i in $patches; do
        header "applying patch $i" 3
        patch -p0 < $i
        stopNest
    done

    configureImakefiles "s:__PREFIX_PNG:${libpng}:"
    configureImakefiles "s:__PREFIX:$out:"

    runHook postPatch
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  preInstall = ''
    mkdir -p $out
    mkdir -p $out/lib
  '';

  hardeningDisable = [ "format" ];

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
