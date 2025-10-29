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

stdenv.mkDerivation {
  pname = "ibus-table-chinese";
  version = "1.8.14";

  src = fetchFromGitHub {
    owner = "mike-fabian";
    repo = "ibus-table-chinese";
    rev = "44301450e681c23d60301747856c74b5b9d1312e";
    sha256 = "sha256-CvODJhQTzqR58IlaL8cIP9Z1gcC8PfkfU0HWdq0Jjms=";
  };

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
    homepage = "https://github.com/mike-fabian/ibus-table-chinese";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pneumaticat ];
  };
}
