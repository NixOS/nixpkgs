{
  lib,
  nix-update-script,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  kwin,
  kpackage,
  zip,
}:
buildNpmPackage (finalAttrs: {
  pname = "krohnkite";
  version = "0.9.8.5";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    tag = finalAttrs.version;
    hash = "sha256-DcNU0nx6KHztfMPFs5PZtZIeu4hDxNYIJa5E1fwMa0Q=";
  };

  npmDepsHash = "sha256-Q/D6s0wOPSEziE1dBXgTakjhXCGvzhvLVS7zXcZlPCI=";

  dontWrapQtApps = true;

  nodejs = nodejs_22;

  nativeBuildInputs = [
    kpackage
    zip
    kwin
  ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmBuildScript = "tsc";

  installPhase = ''
    runHook preInstall

    substituteInPlace Makefile --replace-fail '7z a -tzip' 'zip -r'
    make KWINPKG_FILE=krohnkite.kwinscript krohnkite.kwinscript
    kpackagetool6 --type=KWin/Script --install=krohnkite.kwinscript --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dynamic Tiling Extension for KWin 6";
    homepage = "https://github.com/anametologin/krohnkite";
    changelog = "https://github.com/anametologin/krohnkite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ben9986
      dramforever
    ];
    platforms = lib.platforms.all;
  };
})
