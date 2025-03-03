{
  lib,
  stdenv,
  fetchFromGitHub,
  satyrographosInstallHook,
  satysfiPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "satysfi-base";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nyuichi";
    repo = "satysfi-base";
    tag = finalAttrs.version;
    hash = "sha256-bgWgGmuSHj/rlmNOtMX6o8E7RShvwnkK4hbqjChWF1U=";
  };

  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [ satyrographosInstallHook ];

  dependencies = with satysfiPackages; [
    fonts-dejavu
    test
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    satyrographosInstallHook $src $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "Complementary collection of useful functions and modules for SATySFi";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
