{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libevdev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swap-keys";
  version = "v1.0";

  src = fetchFromGitHub {
    owner = "amfranz";
    repo = "swap-keys";
    rev = finalAttrs.version;
    hash = "sha256-fAFlcxJlsc1kITxCaSMH8Fi2AXlgK8EHayoWWN1hC70=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libevdev ];

  meta = {
    homepage = "https://github.com/amfranz/swap-keys";
    description = "Swap arbitrary pairs of keys";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chairbender ];
    platforms = lib.platforms.linux;
    mainProgram = "swap-keys";
  };
})
