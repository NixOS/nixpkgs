{ fetchurl, pkgs, stdenv, qt5, yajl, gl117, zziplib, quazip, zlib, zip, lua5_1, hunspell, boost, libzip }:

stdenv.mkDerivation rec {
  name = "mudlet-2.0";

  src = fetchurl {
    url = "http://sourceforge.net/code-snapshots/git/m/mu/mudlet/code.git/mudlet-code-f30a55f176c853d1b4ef9f0da8069213f27eaa57.zip";
    sha256 = "d4246b095bf07c3029653e6330078a6f2eddcdbe3267a43b0f4a95c94251be07";
  };

  buildInputs = [ pkgs.unzip qt5 lua5_1 boost hunspell libzip yajl gl117 quazip zziplib ];

  configurePhase = "cd src && qmake";

  installPhase = let
    bin_dir = "$out/bin";
  in ''
    mkdir -pv $out;
    mkdir -pv ${bin_dir};
    cp mudlet ${bin_dir};
    cp -r mudlet-lua ${bin_dir};
  '';

  patches = [ ./libs.patch ];

  meta = {
    description = "Crossplatform mud client";
    homepage = http://mudlet.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.free;
  };
}
