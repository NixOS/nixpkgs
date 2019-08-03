{ fetchpatch, fetchurl, stdenv, libGLU, freeglut, libX11, plib, openal, freealut, libXrandr, xorgproto,
libXext, libSM, libICE, libXi, libXt, libXrender, libXxf86vm, libvorbis,
libpng, zlib, makeWrapper }:

stdenv.mkDerivation rec {
  name = "torcs-1.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/torcs/${name}.tar.bz2";
    sha256 = "0kdq0sc7dsfzlr0ggbxggcbkivc6yp30nqwjwcaxg9295s3b06wa";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/fb0711c171b38c4648dc7c048249ec20f79eb8e2/debian/patches/gcc6-isnan.patch";
      sha256 = "16scmq30vwb8429ah9d4ws0v1w6ai59lvn7hcgnvfzyap42ry876";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/fb0711c171b38c4648dc7c048249ec20f79eb8e2/debian/patches/format-argument.patch";
      sha256 = "04advcx88yh23ww767iysydzhp370x7cqp2wf9hk2y1qvw7mxsja";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/fb0711c171b38c4648dc7c048249ec20f79eb8e2/debian/patches/glibc-default-source.patch";
      sha256 = "0k4hgpddnhv68mdc9ics7ah8q54j60g394d7zmcmzg6l3bjd9pyp";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/games-team/torcs/raw/32bbe77c68b4de07b28c34497f3c0ad666ee618d/debian/patches/gcc7.patch";
      sha256 = "09iilnvdv8h7b4nb1372arszkbz9hbzsck4rimzz1xjdh9ydniw9";
    })
  ];

  postPatch = ''
    sed -i -e s,/bin/bash,`type -P bash`, src/linux/torcs.in
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libGLU freeglut libX11 plib openal freealut libXrandr xorgproto
    libXext libSM libICE libXi libXt libXrender libXxf86vm libpng zlib libvorbis ];

  installTargets = "install datainstall";

  meta = {
    description = "Car racing game";
    homepage = http://torcs.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
