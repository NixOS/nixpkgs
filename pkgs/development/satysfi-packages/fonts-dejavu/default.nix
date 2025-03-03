{
  lib,
  stdenv,
  fetchFromGitHub,
  satyrographosInstallHook,
  dejavu_fonts,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "satysfi-fonts-dejavu";
  version = "2.37+satysfi0.0.4";

  src = fetchFromGitHub {
    owner = "zeptometer";
    repo = "SATySFi-fonts-dejavu";
    tag = finalAttrs.version;
    hash = "sha256-y2tigU06C8fs8s+ImxMPUcdQwdj9mGzyRHNdC+TNR+4=";
  };

  dontBuild = true;

  nativeBuildInputs = [ satyrographosInstallHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    tmpDir=$(mktemp -d)
    mkdir -p $tmpDir/dejavu
    cp -r $src/* $tmpDir
    cp -rL ${dejavu_fonts}/share/fonts/truetype/* $tmpDir/dejavu
    satyrographosInstallHook $tmpDir $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "SATySFi font package for DejaVu fonts";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
