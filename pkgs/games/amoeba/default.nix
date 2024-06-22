{ lib, stdenv, fetchurl, amoeba-data, alsa-lib, expat, freetype, gtk3, libvorbis, libGLU, xorg, pkg-config, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "amoeba";
  version = "1.1";
  debver = "31";

  srcs = [
    (fetchurl {
      url = "http://http.debian.net/debian/pool/contrib/a/amoeba/amoeba_${version}.orig.tar.gz";
      hash = "sha256-NT6oMuAlTcVZEnYjMCF+BD+k3/w7LfWEmj6bkQln3sM=";
    })
    (fetchurl {
      url = "http://http.debian.net/debian/pool/contrib/a/amoeba/amoeba_${version}-${debver}.debian.tar.xz";
      hash = "sha256-Ga/YeXbPXjkG/6qd9Z201d14Hlj/Je6DxgzeIQOqrWc=";
    })
  ];
  sourceRoot = "amoeba-1.1.orig";

  prePatch = ''
    patches="${./include-string-h.patch} $(echo ../debian/patches/*.diff)"
  '';
  postPatch = ''
    sed -i packer/pakfile.cpp -e 's|/usr/share/amoeba|${amoeba-data}/share/amoeba|'
    sed -i main/linux-config/linux-config.cpp -e 's|libgdk-x11-2.0.so.0|${gtk3}/lib/&|'
    sed -i main/linux-config/linux-config.cpp -e 's|libgtk-x11-2.0.so.0|${gtk3}/lib/&|'
  '';

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ alsa-lib expat freetype gtk3 libvorbis libGLU xorg.libXxf86vm ];

  installPhase = ''
    mkdir -p $out/bin
    cp amoeba $out/bin/
    installManPage ../debian/amoeba.1
  '';

  meta = with lib; {
    description = "Fast-paced, polished OpenGL demonstration by Excess";
    homepage = "https://packages.qa.debian.org/a/amoeba.html";
    license = licenses.gpl2; # Engine is GPLv2, data files in amoeba-data nonfree
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
