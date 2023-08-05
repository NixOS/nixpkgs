{ lib
, stdenv
, fetchFromGitHub
, zigHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-M0GG4KIMcHN+bEprUv6ISZkWNvWN12S9vqSKP+DRU9M=";
  };

  nativeBuildInputs = [
    zigHook
  ];

  dontConfigure = true;

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fortuneteller2k ];
    platforms = lib.platforms.unix;
  };
})
