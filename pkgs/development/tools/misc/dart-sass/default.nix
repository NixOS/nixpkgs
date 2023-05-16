{ lib
, fetchFromGitHub
, buildDartApplication
<<<<<<< HEAD
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
  version = "1.66.1";
=======
}:

buildDartApplication rec {
  pname = "dart-sass";
  version = "1.62.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-2bqYoWG8xGh7HGZyCPLNz/ZWXH29Be12YfYgGTCIVx8=";
  };

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-oLHHKV5tTgEkCzqRscBXMNafKg4jdH2U9MhVY/Myfv4=";

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
=======
    hash = "sha256-U6enz8yJcc4Wf8m54eYIAnVg/jsGi247Wy8lp1r1wg4=";
  };

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-Atm7zfnDambN/BmmUf4BG0yUz/y6xWzf0reDw3Ad41s=";

  dartCompileFlags = "--define=version=${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/sass/dart-sass";
    description = "The reference implementation of Sass, written in Dart";
    mainProgram = "sass";
    license = licenses.mit;
    maintainers = with maintainers; [ lelgenio ];
  };
<<<<<<< HEAD

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
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
