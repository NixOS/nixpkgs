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
  version = "5.1.9";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/${pname}/${pname}-${version}.tar.zst";
    hash = "sha256-+aIb7ktmhKb6ixhvzCG6GLeEUfS3QHJmEZ3YGE5YrZg=";
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
    postBuild = "mkdir -p $out/share/rime-data";
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
