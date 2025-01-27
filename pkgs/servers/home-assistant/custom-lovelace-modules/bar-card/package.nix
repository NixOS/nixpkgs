{
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "bar-card";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "custom-cards";
    repo = "bar-card";
    tag = version;
    hash = "sha256-1Bfj+JBMj3hMZW55oyA9DzKr0z5TOW1Zo9mEuD4rz1o=";
  };
  patches = [
    ./fix-ts-ignore.patch
    ./fixup-yarn-lock.patch
  ];
  offlineCache = fetchYarnDeps {
    inherit src;
    hash = "sha256-f/kFCxIinW/9Po0pZM9V8i0ySqiGqz1rmEEFSvw1Gk4=";
    patches = [
      ./fix-ts-ignore.patch
      ./fixup-yarn-lock.patch
    ];
  };
  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp dist/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Customizable Animated Bar card for Home Assistant Lovelace";
    homepage = "https://github.com/custom-cards/bar-card";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ patrickdag ];
  };
}
