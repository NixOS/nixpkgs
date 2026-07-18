{
  buildDartApplication,
  lib,
  runCommand,
}:

let
  application = buildDartApplication {
    pname = "dart-sqlite3-test";
    version = "0.0.1";

    src = ./.;
    pubspecLock = lib.importJSON ./pubspec.lock.json;

    buildPhase = ''
      runHook preBuild

      dart build cli --output build/cli --target bin/main.dart

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -r build/cli/bundle/. "$out"

      runHook postInstall
    '';
  };
in
runCommand "test-dart-sqlite3" { } ''
  result=$(${application}/bin/main)
  test "$result" = 42
  touch "$out"
''
