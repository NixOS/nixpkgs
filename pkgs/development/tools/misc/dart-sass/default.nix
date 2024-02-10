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
  embedded-protocol-version = "2.4.0";

  embedded-protocol = fetchFromGitHub {
    owner = "sass";
    repo = "sass";
    rev = "refs/tags/embedded-protocol-${embedded-protocol-version}";
    hash = "sha256-19YQTda5su2PI2vLzVRCn7fQoH5vEg3539gXEeLLvV8=";
  };
in
buildDartApplication rec {
  pname = "dart-sass";
  version = "1.70.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-JLVcoDAngP1y8EC4K6fIJdPu2Xm8LLAxUm8BTK5tSVk=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    buf
    protoc-gen-dart
  ];

  preConfigure = ''
    mkdir -p build
    ln -s ${embedded-protocol} build/language
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

  passthru = {
    inherit embedded-protocol-version embedded-protocol;
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion {
        package = dart-sass;
        command = "dart-sass --version";
      };

      simple = testers.testEqualContents {
        assertion = "dart-sass compiles a basic scss file";
        expected = writeText "expected" ''
          body h1{color:#123}
        '';
        actual = runCommand "actual"
          {
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
  };
}
