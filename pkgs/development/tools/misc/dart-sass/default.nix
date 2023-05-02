{ lib
, stdenvNoCC
, fetchFromGitHub
, dart
, callPackage
}:

stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "dart-sass";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = finalAttrs.version;
    hash = "sha256-U6enz8yJcc4Wf8m54eYIAnVg/jsGi247Wy8lp1r1wg4=";
  };

  nativeBuildInputs = [
    dart
    (callPackage ../../../../build-support/dart/fetch-dart-deps { } {
      buildDrvArgs = finalAttrs;
      pubspecLockFile = ./pubspec.lock;
      vendorHash = "sha256-Atm7zfnDambN/BmmUf4BG0yUz/y6xWzf0reDw3Ad41s=";
    })
  ];

  configurePhase = ''
    runHook preConfigure
    dart pub get --offline
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    dart compile exe --define=version=${finalAttrs.version} ./bin/sass.dart
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D ./bin/sass.exe $out/bin/sass
    runHook postInstall
  '';

  meta = with lib; {
    inherit (dart.meta) platforms;
    homepage = "https://github.com/sass/dart-sass";
    description = "The reference implementation of Sass, written in Dart";
    mainProgram = "sass";
    license = licenses.mit;
    maintainers = with maintainers; [ lelgenio ];
  };
})
