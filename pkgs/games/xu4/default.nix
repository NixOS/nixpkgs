{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, zlib
, libpng
, boron
, libGL
, libX11
, libXxf86vm
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
  '';

  enableParallelBuilding = true;

  buildInputs = [
    zlib
    libpng
    boron
    libGL
    libX11
    libXxf86vm
    libXcursor
    faun
  ];

  nativeBuildInputs = [ makeWrapper ];

  # The `install` target references some files with unknown license
  installPhase =
  ''
    install -D -m 755 src/xu4 $out/share/xu4
    install -D -m 644 Ultima-IV.mod $out/share/Ultima-IV.mod
    install -D -m 644 U4-Upgrade.mod $out/share/U4-Upgrade.mod
    install -D -m 644 render.pak $out/share/render.pak
    install -D icons/xu4.png $out/share/icons/hicolor/48x48/apps/xu4.png
    install -D -m 644 dist/xu4.desktop $out/share/applications/xu4.desktop
    makeWrapper $out/share/xu4 $out/bin/xu4 --chdir $out/share
  '';

  meta = with lib; {
    homepage = "http://xu4.sourceforge.net/";
    description = "Remake of the computer game Ultima IV";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];  # aarch64 won't compile
    maintainers = with maintainers; [ mausch ];
  };
}
