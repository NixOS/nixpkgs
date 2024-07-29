{ lib
, fetchFromGitHub
, buildDartApplication
}:
let
pname = "melos";
version = "3.4.0";
repo = fetchFromGitHub {
    owner = "invertase";
    repo = pname;
    rev = "melos-v${version}";
    hash = "sha256-8G0pARg6jeYzV6XhjvrauazCKDp/G54uZ0o7o9UtLq4=";
  };
in
buildDartApplication {
  inherit pname version;

  src = "${repo}/packages/melos";

  patches = [ ./add-generic-main.patch ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  depsListFile = ./deps.json;
  vendorHash = "sha256-h8HfXJOQcfaBlh54/2ODUgswa5vCGgb/5YthutDvOEI=";

  meta = with lib; {
    homepage = "https://github.com/invertase/melos";
    description = "🌋 A tool for managing Dart projects with multiple packages. With IntelliJ and Vscode IDE support. Supports automated versioning, changelogs & publishing via Conventional Commits. ";
    mainProgram = "melos";
    license = licenses.asl20;
    maintainers = with maintainers; [ eymeric ];
  };

  # hard code the path to the melos templates
  preBuild = ''
    substituteInPlace lib/src/common/utils.dart --replace final\ melosPackageFileUri\ =\ await\ Isolate.resolvePackageUri\(melosPackageUri\)\; return\ \"$out\"\;
    substituteInPlace lib/src/common/utils.dart --replace return\ p.normalize\(\'\$\{melosPackageFileUri!.toFilePath\(\)}/../..\'\)\; " "
    mkdir -p $out/templates
    cp -r $src/templates $out
  '';

  # we can't run the tests because they depand on melos supdirectory.
  }
