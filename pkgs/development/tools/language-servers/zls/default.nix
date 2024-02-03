{ lib
, stdenv
, fetchFromGitHub
, zig_0_11
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
    zig_0_11.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda moni ];
    platforms = lib.platforms.unix;
  };
})
