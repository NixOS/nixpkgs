<<<<<<< HEAD
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
    maintainers = with lib.maintainers; [ figsoda fortuneteller2k ];
    platforms = lib.platforms.unix;
  };
})
=======
{ stdenv, lib, fetchFromGitHub, zig }:

stdenv.mkDerivation rec {
  pname = "zls";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = pname;
    rev = version;
    sha256 = "sha256-M0GG4KIMcHN+bEprUv6ISZkWNvWN12S9vqSKP+DRU9M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ zig ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zig LSP implementation + Zig Language Server";
    changelog = "https://github.com/zigtools/zls/releases/tag/${version}";
    homepage = "https://github.com/zigtools/zls";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
