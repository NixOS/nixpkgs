{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, zlib
, libpng
, boron
, libGL
, libX11
, libXcursor
, faun
}:

stdenv.mkDerivation rec {
  pname = "xu4";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "xu4-engine";
    repo = "u4";
    rev = "v${version}";
    hash = "sha256-3jyUSVfmjuKsHQKluFnQ8Gtg7aAI/WBjmY109BdNdyY=";
    fetchSubmodules = true;
  };

  # this is not a standard Autotools-like `configure` script
  dontAddPrefix = true;

  preConfigure = ''
    patchShebangs configure
  '';

  postConfigure = ''
    # need to report this upstream
    sed --in-place 's/-Wall/-Wno-error=format-security/g' src/Makefile

    # disable git submodule init as part of build
    sed --in-place 's/^\s*git submodule.*//g' src/Makefile.common

    # set binary version (ref https://github.com/NixOS/nixpkgs/commit/571e02812f5da12fd851557ebbacea72fc7b5121#r129407907 )
    sed --in-place 's/DR-1.0/${version}/' src/Makefile.common
  '';

  enableParallelBuilding = true;

  buildInputs = [
    zlib
    libpng
    boron
    libGL
    libX11
    libXcursor
    faun
  ];

  nativeBuildInputs = [ makeWrapper ];

  # The `install` target references some files with unknown license
  installPhase = ''
    install -D -m 755 src/xu4 $out/share/xu4
    install -D -m 644 Ultima-IV.mod $out/share/Ultima-IV.mod
    install -D -m 644 U4-Upgrade.mod $out/share/U4-Upgrade.mod
    install -D -m 644 render.pak $out/share/render.pak
    install -D icons/xu4.png $out/share/icons/hicolor/48x48/apps/xu4.png
    install -D -m 644 dist/xu4.desktop $out/share/applications/xu4.desktop
    makeWrapper $out/share/xu4 $out/bin/xu4 --chdir $out/share
  '';

  meta = with lib; {
    homepage = "https://xu4.sourceforge.net/";
    description = "Remake of the computer game Ultima IV";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mausch ];
  };
}
