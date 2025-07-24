{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # buildInputs
  rizin,
  openssl,
  pugixml,
  # optional buildInputs
  enableCutterPlugin ? true,
  cutter,
  qt5compat,
  qtbase,
  qtsvg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rz-ghidra";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "rz-ghidra";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uI0EnuHAuyrXYKDijh5Tg/WcQ/5yyZnW3d5MMHZxnqA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    pugixml
    rizin
  ]
  ++ lib.optionals enableCutterPlugin [
    cutter
    qt5compat
    qtbase
    qtsvg
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_PUGIXML=ON"
  ]
  ++ lib.optionals enableCutterPlugin [
    "-DBUILD_CUTTER_PLUGIN=ON"
    "-DCUTTER_INSTALL_PLUGDIR=share/rizin/cutter/plugins/native"
  ];

  meta = with lib; {
    # errors out with undefined symbols from Cutter
    broken = enableCutterPlugin && stdenv.hostPlatform.isDarwin;
    description = "Deep ghidra decompiler and sleigh disassembler integration for rizin";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.src.rev}";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chayleaf ];
    inherit (rizin.meta) platforms;
  };
})
