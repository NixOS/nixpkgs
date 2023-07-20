{ lib
, fetchFromGitHub
, buildDartApplication
, buf
, protoc-gen-dart
, testers
, dart-sass
, runCommand
, writeText
}:

let
  sass-language = fetchFromGitHub {
    owner = "sass";
    repo = "sass";
    rev = "refs/tags/embedded-protocol-2.0.0";
    hash = "sha256-3qk3XbI/DpNj4oa/3ar5hqEY8LNmQsokinuKt4xV7ck=";
  };
in
buildDartApplication rec {
  pname = "dart-sass";
  version = "1.65.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-q6UY+A7JFDYb9hzvr2SYI9GfkY9bg49fQkUM7gHKOBU=";
  };

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-nIiffqM5HwJmORdONz+RADAPTISrz/3/HxK4aOSl5cM=";

  nativeBuildInputs = [
    buf
    protoc-gen-dart
  ];

  preConfigure = ''
    mkdir -p build
    ln -s ${sass-language} build/language
    HOME="$TMPDIR" buf generate
  '';

  dartCompileFlags = [ "--define=version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/sass/dart-sass";
    description = "The reference implementation of Sass, written in Dart";
    mainProgram = "sass";
    license = licenses.mit;
    maintainers = with maintainers; [ lelgenio ];
  };

  passthru.tests = {
    version = testers.testVersion {
      package = dart-sass;
      command = "dart-sass --version";
    };

    simple = testers.testEqualContents {
      assertion = "dart-sass compiles a basic scss file";
      expected = writeText "expected" ''
        body h1{color:#123}
      '';
      actual = runCommand "actual" {
        nativeBuildInputs = [ dart-sass ];
        base = writeText "base" ''
          body {
            $color: #123;
            h1 {
              color: $color;
            }
          }
        '';
      } ''
        dart-sass --style=compressed $base > $out
      '';
    };
  };
}
