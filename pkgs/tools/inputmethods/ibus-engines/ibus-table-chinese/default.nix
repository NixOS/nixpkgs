{ stdenv, fetchgit, fetchFromGitHub, pkgconfig,  ibus, ibus-table, python3, cmake }:

let
  src = fetchFromGitHub {
    owner = "definite";
    repo = "ibus-table-chinese";
    rev = "f1f6a3384f021caa3b84c517e2495086f9c34507";
    sha256 = "14wpw3pvyrrqvg7al37jk2dxqfj9r4zf88j8k2n2lmdc50f3xs7k";
  };

  cmakeFedoraSrc = fetchgit {
    url = "https://pagure.io/cmake-fedora.git";
    rev = "7d5297759aef4cd086bdfa30cf6d4b2ad9446992";
    sha256 = "0mx9jvxpiva9v2ffaqlyny48iqr073h84yw8ln43z2avv11ipr7n";
  };
in stdenv.mkDerivation rec {
  name = "ibus-table-chinese-${version}";
  version = "1.8.2";

  srcs = [ src cmakeFedoraSrc ];
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
  cmakeFlags = [ "-DPRJ_INFO_CMAKE_FILE=/dev/null" "-DPRJ_DOC_DIR=REPLACE" "-DDATA_DIR=share" ];
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

  buildInputs = [ pkgconfig ibus ibus-table python3 cmake ];

  meta = with stdenv.lib; {
    isIbusEngine = true;
    description  = "Chinese tables for IBus-Table";
    homepage     = https://github.com/definite/ibus-table-chinese;
    license      = licenses.gpl3;
    platforms    = platforms.linux;
    maintainers  = with maintainers; [ pneumaticat ];
  };
}
