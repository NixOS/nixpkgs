{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "aerothemeplasma-sounds";
  version = "6.6.1-unstable-2026-02-27";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    group = "aeroshell";
    owner = "atp";
    repo = "aerothemeplasma-sounds";
    rev = "55d2f5fd15f53cccbbb13388941b930442db1159";
    hash = "sha256-z73owMl2+mAQJKGgjuJAmPIYOYuoVug0nWZ3WqWY0DY=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Windows 7 Sound Theme Collection for AeroThemePlasma";
    homepage = "https://gitgud.io/aeroshell/atp/aerothemeplasma-sounds";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.all;
  };
}
