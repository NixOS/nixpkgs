{ lib
, stdenv
, fetchFromGitHub
, zigHook
, callPackage
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-WrbjJyc4pj7R4qExdzd0DOQ9Tz3TFensAfHdecBA8UI=";
  };

  nativeBuildInputs = [
    zigHook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda fortuneteller2k ];
    platforms = lib.platforms.unix;
  };
})
