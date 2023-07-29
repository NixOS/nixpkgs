{ lib
, fetchFromGitHub
, buildDartApplication
, buf
, protoc-gen-dart
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
  version = "1.64.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    hash = "sha256-JIw1I60Av5hUSRyqhc4nK5x9gHJcHTUIdYBTfQf8ob4=";
  };

  pubspecLockFile = ./pubspec.lock;
  vendorHash = "sha256-kGeQIlNTHhlIEFH4MdWF5smc9lLg4YHx11bZS4BTPgI=";

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
}
