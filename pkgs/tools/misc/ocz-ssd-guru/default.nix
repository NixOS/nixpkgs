{ fetchurl, stdenv, xorg, freetype, fontconfig, libGLU_combined, glibc, makeWrapper }:

let
  system = if stdenv.hostPlatform.system == "x86_64-linux" then "linux64" else "linux32";
in
stdenv.mkDerivation rec {
  name = "ocz-ssd-guru-${version}";
  version = "1.0.1170";

  src = fetchurl {
    url = "http://ocz.com/consumer/download/ssd-guru/SSDGuru_${version}.tar.gz";
    sha256 = "0ri7qmpc1xpy12lpzl6k298c641wcibcwrzz8jn75wdg4rr176r5";
  };

  buildInputs = [ makeWrapper ];

  libPath = stdenv.lib.makeLibraryPath [
      xorg.libX11
      xorg.libxcb
      freetype
      fontconfig
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      stdenv.cc.cc
      glibc
      libGLU_combined
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${system}/SSDGuru $out/bin/
    rm -rf linux{32,64}
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath:$out \
      $out/bin/SSDGuru

    wrapProgram $out/bin/SSDGuru --prefix LD_LIBRARY_PATH : $libPath
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = http://ocz.com/ssd-guru;
    description = "SSD Management Tool for OCZ disks";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jagajaga ];
  };

}
