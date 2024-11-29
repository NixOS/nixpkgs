{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  kwin,
  kpackage,
  zip,
}:
buildNpmPackage rec {
  pname = "krohnkite";
  version = "0.9.8.3";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = "krohnkite";
    rev = "refs/tags/${version}";
    hash = "sha256-PiGpYOKvBpwkPfDWHlOhq7dwyBYzfzfJVURiEC1a78g=";
  };

  npmDepsHash = "sha256-IUGRxDCn/aEebCgDPElEPKOxfoYmLoFHVROkTJpNISY=";

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

  meta = {
    description = "Dynamic Tiling Extension for KWin 6";
    homepage = "https://github.com/anametologin/krohnkite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ben9986 ];
    platforms = lib.platforms.all;
  };
}
