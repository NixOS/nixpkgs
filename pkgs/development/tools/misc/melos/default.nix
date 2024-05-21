{ lib
, fetchFromGitHub
, buildDartApplication
}:
let
pname = "melos";
version = "6.1.0";
repo = fetchFromGitHub {
    owner = "invertase";
    repo = pname;
    rev = "melos-v${version}";
    hash = "sha256-QebhZpPK2OBRUH/7cz8g9WGgKiYuFznvBp4xrRjSpVA=";
  };
in
buildDartApplication {
  inherit pname version;

  src = "${repo}/packages/melos";

  patches = [ ./add-generic-main.patch ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

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
