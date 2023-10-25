{ lib
, fetchFromGitHub
, buildDartApplication
, buf
, protoc-gen-dart
}:

let
  embedded-protocol = fetchFromGitHub {
    owner = "sass";
    repo = "embedded-protocol";
    rev = "refs/tags/1.2.0";
    hash = "sha256-OHOWotI+cXjDhEYUNXa36FpMEW7hSIu8gVX3gVRvw2Y=";
  };

  self = buildDartApplication rec {
    pname = "dart-sass-embedded";
    version = "1.62.1";

    src = fetchFromGitHub {
      owner = "sass";
      repo = "dart-sass-embedded";
      rev = "refs/tags/${version}";
      hash = "sha256-GpSus5/QItbzCrOImMvrO6DTAQeODABRNiSYHJlLlIA=";
    };

    pubspecLock = lib.importJSON ./pubspec.lock.json;
    depsListFile = ./deps.json;

    gitHashes = {
      sass_analysis = "sha256-rzGgY3ZSKICM2fNRKuZWWe5UOQl5MKV4NQa0bEYZO/M=";
    };

    nativeBuildInputs = [
      buf
      (protoc-gen-dart.overrideAttrs ({ ... }: rec {
        src = self.pubspecLock.dependencySources.protoc_plugin;
        sourceRoot = src.name;
      }))
    ];

    preConfigure = ''
      mkdir -p build
      ln -s '${embedded-protocol}' build/embedded-protocol
    '';

    preBuild = ''
      HOME="$TMPDIR" buf generate
    '';

    meta = with lib; {
      description = "A wrapper for Dart Sass that implements the compiler side of the Embedded Sass protocol";
      homepage = "https://github.com/sass/dart-sass-embedded";
      changelog = "https://github.com/sass/dart-sass-embedded/blob/${version}/CHANGELOG.md";
      license = licenses.mit;
      maintainers = with maintainers; [ shyim ];
    };
  };
in
self
