{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  cmake,
  extra-cmake-modules,
  gettext,
  zstd,
  fcitx5,
  librime,
  rime-data,
  symlinkJoin,
  rimeDataPkgs ? [ rime-data ],
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-rime";
  version = "5.1.12";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/${pname}/${pname}-${version}.tar.zst";
    hash = "sha256-A7x7PQiyPAprJRg1tdk1Amq7pAhe8ney2KX9+9F0mK4=";
  };

  cmakeFlags = [
    "-DRIME_DATA_DIR=${placeholder "out"}/share/rime-data"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
    zstd
  ];

  buildInputs = [
    fcitx5
    librime
  ];

  rimeDataDrv = symlinkJoin {
    name = "fcitx5-rime-data";
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

  meta = with lib; {
    description = "RIME support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-rime";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
