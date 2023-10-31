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
    rev = "refs/tags/embedded-protocol-2.3.0";
    hash = "sha256-J2heASfIwj4lxjsRs/0zRHSaF2tij9bO7IgXp0u/eiI=";
  };
in
buildDartApplication rec {
  pname = "dart-sass";
  version = "1.69.5";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-tf/kBnzEgNKqQsmXh8/9LJid4IOu8JjqaoHJm6neg6E=";
  };

  depsListFile = ./deps.json;
  vendorHash = "sha256-4afX/ukTG4OxdXd8eaKjYudAxAIqZlKKOwLPYARUIOg=";

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
