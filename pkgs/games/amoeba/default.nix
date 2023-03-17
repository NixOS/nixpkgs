{ lib, stdenv, fetchurl, amoeba-data, alsa-lib, expat, freetype, gtk2, libvorbis, libGLU, xorg, pkg-config }:

stdenv.mkDerivation rec {
  pname = "amoeba";
  version = "1.1";
  debver = "29.1";

  srcs = [
    (fetchurl {
      url = "http://http.debian.net/debian/pool/contrib/a/amoeba/amoeba_${version}.orig.tar.gz";
      sha256 = "1hyycw4r36ryka2gab9vzkgs8gq4gqhk08vn29cwak95w0rahgim";
    })
    (fetchurl {
      url = "http://http.debian.net/debian/pool/contrib/a/amoeba/amoeba_${version}-${debver}.debian.tar.xz";
      sha256 = "1xgi2sqzq97w6hd3dcyq6cka8xmp6nr25qymzhk52cwqh7qb75p3";
    })
  ];
  sourceRoot = "amoeba-1.1.orig";

  prePatch = ''
    patches="${./include-string-h.patch} $(echo ../debian/patches/*.diff)"
  '';
  postPatch = ''
    sed -i packer/pakfile.cpp -e 's|/usr/share/amoeba|${amoeba-data}/share/amoeba|'
    sed -i main/linux-config/linux-config.cpp -e 's|libgdk-x11-2.0.so.0|${gtk2}/lib/&|'
    sed -i main/linux-config/linux-config.cpp -e 's|libgtk-x11-2.0.so.0|${gtk2}/lib/&|'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib expat freetype gtk2 libvorbis libGLU xorg.libXxf86vm ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1/
    cp amoeba $out/bin/
    cp ../debian/amoeba.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "Fast-paced, polished OpenGL demonstration by Excess";
    homepage = "https://packages.qa.debian.org/a/amoeba.html";
    license = licenses.gpl2; # Engine is GPLv2, data files in amoeba-data nonfree
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
