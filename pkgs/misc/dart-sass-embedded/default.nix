{ lib
, stdenvNoCC
, fetchFromGitHub
, dart
, buf
, callPackage
, runtimeShell
}:

let
  embedded-protocol = fetchFromGitHub {
    owner = "sass";
    repo = "embedded-protocol";
    rev = "refs/tags/1.2.0";
    hash = "sha256-OHOWotI+cXjDhEYUNXa36FpMEW7hSIu8gVX3gVRvw2Y=";
  };

  libExt = stdenvNoCC.hostPlatform.extensions.sharedLibrary;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dart-sass-embedded";
  version = "1.62.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "dart-sass-embedded";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-GpSus5/QItbzCrOImMvrO6DTAQeODABRNiSYHJlLlIA=";
  };

  nativeBuildInputs = [
    buf
    dart
    (callPackage ../../build-support/dart/fetch-dart-deps { } {
      buildDrvArgs = finalAttrs;
      vendorHash = "sha256-aEBE+z8M5ivMR9zL7kleBJ8c9T+4PGXoec56iwHVT+c=";
    })
  ];

  strictDeps = true;

  configurePhase = ''
    runHook preConfigure
    dart pub get --offline
    mkdir build
    ln -s ${embedded-protocol} build/embedded-protocol
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    UPDATE_SASS_PROTOCOL=false HOME="$TMPDIR" dart run grinder protobuf
    dart run grinder pkg-compile-native
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib" "$out/bin"
    cp build/dart-sass-embedded.native "$out/lib/dart-sass-embedded${libExt}"
    echo '#!${runtimeShell}' > "$out/bin/dart-sass-embedded"
    echo "exec ${dart}/bin/dartaotruntime $out/lib/dart-sass-embedded${libExt} \"\$@\"" >> "$out/bin/dart-sass-embedded"
    chmod +x "$out/bin/dart-sass-embedded"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A wrapper for Dart Sass that implements the compiler side of the Embedded Sass protocol";
    homepage = "https://github.com/sass/dart-sass-embedded";
    changelog = "https://github.com/sass/dart-sass-embedded/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
})
