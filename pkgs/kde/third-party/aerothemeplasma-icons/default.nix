{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "aerothemeplasma-icons";
  version = "6.6.1-unstable-2026-06-20";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    group = "aeroshell";
    owner = "atp";
    repo = "aerothemeplasma-icons";
    rev = "96950b8028a5d960cb683280fe5f1d9e33e6b8a2";
    hash = "sha256-7dfoGD3LQiBQ7/JeM1CwAZ+NNMaAJyAN/SaYIHZl1xg=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Windows 7 Icon Theme for AeroThemePlasma";
    homepage = "https://gitgud.io/aeroshell/atp/aerothemeplasma-icons";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.all;
  };
}
