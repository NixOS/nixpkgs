{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ibus,
  ibus-table,
  python3,
  cmake,
  writableTmpDirAsHomeHook,
}:

let
  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-table-chinese";
    rev = "3a416012f3b898fe17225925f59d0672a8a0c0db";
    sha256 = "sha256-KA4jRSlQ78IeP7od3VtgdR58Z/6psNkMCVwvg3vhFIM=";
  };
in
stdenv.mkDerivation {
  pname = "ibus-table-chinese";
  version = "1.8.12";

  inherit src;

  postConfigure = ''
    substituteInPlace cmake_install.cmake --replace-fail /var/empty $out
    substituteInPlace CMakeLists.txt --replace-fail /var/empty $out
  '';
  # Fails otherwise with "no such file or directory: <table>.txt"
  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook
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
