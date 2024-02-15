{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
# buildInputs
, rizin
, openssl
, pugixml
# optional buildInputs
, enableCutterPlugin ? true
, cutter
, qt5compat
, qtbase
, qtsvg
}:

stdenv.mkDerivation rec {
  pname = "rz-ghidra";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "rz-ghidra";
    rev = "v${version}";
    hash = "sha256-tQAurouRr6fP1tbIkfd0a9UfeYcwiU1BpjOTcooXkT0=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rizinorg/rz-ghidra/pull/327/commits/eba20e2c743ed3dfc5d1be090a5018f7267baa49.patch";
      hash = "sha256-aoXFClXZBcOnHl+6lLYrnui7sRb3cRJQhQfNDLxHtcs=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    pugixml
    rizin
  ] ++ lib.optionals enableCutterPlugin [
    cutter
    qt5compat
    qtbase
    qtsvg
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_PUGIXML=ON"
  ] ++ lib.optionals enableCutterPlugin [
    "-DBUILD_CUTTER_PLUGIN=ON"
    "-DCUTTER_INSTALL_PLUGDIR=share/rizin/cutter/plugins/native"
  ];

  meta = with lib; {
    # errors out with undefined symbols from Cutter
    broken = enableCutterPlugin && stdenv.isDarwin;
    description = "Deep ghidra decompiler and sleigh disassembler integration for rizin";
    homepage = src.meta.homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chayleaf ];
    inherit (rizin.meta) platforms;
  };
}
