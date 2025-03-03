{
  lib,
  fetchFromGitHub,
  stdenv,
  satyrographosInstallHook,
  satysfiPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "satysfi-fss";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "na4zagin3";
    repo = "satysfi-fss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9MLw4A5pF5f3KY5r7v+bDV9BAaPzKRh1Yi+dQi5QMPs=";
  };

  dontBuild = true;

  nativeBuildInputs = [ satyrographosInstallHook ];

  dependencies = with satysfiPackages; [
    base
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    satyrographosInstallHook $src $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "Font Selection Scheme for SATySFi";
    homepage = "https://github.com/na4zagin3/satysfi-fss";
    changelog = "https://github.com/na4zagin3/satysfi-fss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
