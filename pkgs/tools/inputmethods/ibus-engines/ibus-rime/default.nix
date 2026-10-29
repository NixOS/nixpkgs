{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gdk-pixbuf,
  glib,
  ibus,
  libnotify,
  librime,
  pkg-config,
  rime-data,
  symlinkJoin,
  rimeDataPkgs ? [ rime-data ],
}:

stdenv.mkDerivation rec {
  pname = "ibus-rime";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "rime";
    repo = "ibus-rime";
    rev = version;
    sha256 = "sha256-prxXFC5l7JKmrKJe2R5U7kKJmb2m06B+Tic+m6LGthM=";
  };

  buildInputs = [
    gdk-pixbuf
    glib
    ibus
    libnotify
    librime
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [ "-DRIME_DATA_DIR=${placeholder "out"}/share/rime-data" ];

  rimeDataDrv = symlinkJoin {
    name = "ibus-rime-data";
    paths = rimeDataPkgs;
    postBuild = ''
      mkdir -p $out/share/rime-data

      # Ensure default.yaml exists
      [ -e "$out/share/rime-data/default.yaml" ] || touch "$out/share/rime-data/default.yaml"
    '';
  };

  postInstall = ''
    cp -r "${rimeDataDrv}/share/rime-data/." $out/share/rime-data/
  '';

  meta = {
    isIbusEngine = true;
    description = "Rime input method engine for IBus";
    homepage = "https://rime.im/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pmy ];
  };
}
