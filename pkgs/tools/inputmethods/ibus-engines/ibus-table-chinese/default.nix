{
  lib,
  stdenv,
  fetchgit,
  fetchFromGitHub,
  pkg-config,
  ibus,
  ibus-table,
  python3,
  cmake,
}:

let
  src = fetchFromGitHub {
    owner = "definite";
    repo = "ibus-table-chinese";
    rev = "3380c96b5230721e9b80685a719508c505b8137a";
    hash = "sha256-Ymzkim1k6KQxcSX2LaczRsxV2DYCFxIWI5xulmhOrw8=";
  };

  cmakeFedoraSrc = fetchgit {
    url = "https://pagure.io/cmake-fedora.git";
    rev = "7d5297759aef4cd086bdfa30cf6d4b2ad9446992";
    hash = "sha256-9uQbQ9hbiT+IpYh7guA4IOOIiLeeYuWc2EntePuWqVc=";
  };
in
stdenv.mkDerivation {
  pname = "ibus-table-chinese";
  version = "1.8.3";

  srcs = [
    src
    cmakeFedoraSrc
  ];

  sourceRoot = src.name;

  postUnpack = ''
    chmod u+w -R ${cmakeFedoraSrc.name}
    mv ${cmakeFedoraSrc.name}/* source/cmake-fedora
  '';

  preConfigure = ''
    # cmake script needs ./Modules folder to link to cmake-fedora
    ln -s cmake-fedora/Modules ./
  '';

  # Fails when writing to /prj_info.cmake in https://pagure.io/cmake-fedora/blob/master/f/Modules/ManageVersion.cmake
  cmakeFlags = [
    "-DPRJ_INFO_CMAKE_FILE=/dev/null"
    "-DPRJ_DOC_DIR=REPLACE"
    "-DDATA_DIR=share"
  ];
  # Must replace PRJ_DOC_DIR with actual share/ folder for ibus-table-chinese
  # Otherwise it tries to write to /ibus-table-chinese if not defined (!)
  postConfigure = ''
    substituteInPlace cmake_install.cmake --replace '/build/source/REPLACE' $out/share/ibus-table-chinese
  '';
  # Fails otherwise with "no such file or directory: <table>.txt"
  dontUseCmakeBuildDir = true;
  # Fails otherwise sometimes with
  # FileExistsError: [Errno 17] File exists: '/build/tmp.BfVAUM4llr/ibus-table-chinese/.local/share/ibus-table'
  enableParallelBuilding = false;

  preBuild = ''
    export HOME=$(mktemp -d)/ibus-table-chinese
  '';

  postFixup = ''
    rm -rf $HOME
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ibus
    ibus-table
    python3
  ];

  meta = {
    isIbusEngine = true;
    description = "Chinese tables for IBus-Table";
    homepage = "https://github.com/definite/ibus-table-chinese";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pneumaticat ];
  };
}
