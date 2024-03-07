{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  version = "1.9.4";
  pname = "antidote";

  src = fetchFromGitHub {
    owner = "mattmc3";
    repo = "antidote";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gZBDLKkLVfHC+DHlaMS/ySUjb14Jo1192JbkDQnzi7c=";
  };

  dontPatch = true;
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -D antidote --target-directory=$out/share/antidote
    install -D antidote.zsh --target-directory=$out/share/antidote
    install -D functions/* --target-directory=$out/share/antidote/functions
    runHook postInstall
  '';

  meta = {
    description = "A zsh plugin manager made from the ground up thinking about performance";
    homepage = "https://getantidote.github.io/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hitsmaxft ];
    platforms = lib.platforms.all;
  };
})
