{
  lib,
  fetchFromGitHub,
  stdenv,
  satyrographosInstallHook,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "satysfi-zrbase";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zr-tex8r";
    repo = "satysfi-zrbase";
    tag = finalAttrs.version;
    hash = "sha256-waqV3IJEeFOoex0vqI8zPogc/t3nDF7gQalm3Gfu0cA=";
  };

  dontBuild = true;

  nativeBuildInputs = [ satyrographosInstallHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/satysfi
    satyrographosInstallHook $src $out/share/satysfi
    runHook postInstall
  '';

  meta = {
    description = "A collection of packages to make programming in SATySFi more comfortable";
    homepage = "https://github.com/zr-tex8r/satysfi-zrbase";
    changelog = "https://github.com/zr-tex8r/satysfi-zrbase/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
