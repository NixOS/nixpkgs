{
  lib,
  nix-update-script,
  buildNpmPackage,
  fetchFromCodeberg,
  kwin,
  kpackage,
  zip,
}:
buildNpmPackage (finalAttrs: {
  pname = "krohnkite";
  version = "0.9.11.0";

  src = fetchFromCodeberg {
    owner = "anametologin";
    repo = "Krohnkite";
    rev = finalAttrs.version;
    hash = "sha256-n3TQFLf4FeJjJ5on8U+VPFqZE553x+uKktsuRtWQZR4=";
  };

  npmDepsHash = "sha256-oyXwDSR6e0dKtvHTm2Y+/2Ad33UeqHWyEe/e1OAwTqo=";

  dontWrapQtApps = true;

  nativeBuildInputs = [
    kpackage
    zip
    kwin
  ];

  npmBuildScript = "tsc";

  installPhase = ''
    runHook preInstall

    substituteInPlace Makefile --replace-fail '7z a -tzip' 'zip -r'
    # Override PROJECT_VER and PROJECT_REV because we don't have .git
    make \
      KWINPKG_FILE=krohnkite.kwinscript \
      PROJECT_REV=${finalAttrs.version} \
      PROJECT_VER=${finalAttrs.version} \
      krohnkite.kwinscript
    kpackagetool6 --type=KWin/Script --install=krohnkite.kwinscript --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic Tiling Extension for KWin 6";
    homepage = "https://codeberg.org/anametologin/Krohnkite";
    changelog = "https://codeberg.org/anametologin/Krohnkite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ben9986
      dramforever
    ];
    platforms = lib.platforms.all;
  };
})
