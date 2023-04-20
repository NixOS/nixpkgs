{ lib
, stdenvNoCC
, fetchurl
, autoPatchelfHook
}:

stdenvNoCC.mkDerivation rec {
  pname = "dart-sass-embedded";
  version = "1.62.1";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  src = let base = "https://github.com/sass/dart-sass-embedded/releases/download/${version}/sass_embedded-${version}"; in
    fetchurl {
      "x86_64-linux" = {
        url = "${base}-linux-x64.tar.gz";
        hash = "sha256-NXTadacyKlOQNGSLj/hP8syhYuuSTXK2Y9cYzTk28HU=";
      };
      "aarch64-linux" = {
        url = "${base}-linux-arm64.tar.gz";
        hash = "sha256-DX29U1AjmqVhKFgzP+71vsdoMjQ13IS93PZ1JLOA7bA=";
      };
      "x86_64-darwin" = {
        url = "${base}-macos-x64.tar.gz";
        hash = "sha256-0oyb9YBKoPNaWFLbIUZOJc5yK11uDYyAKKW4urkmRJQ=";
      };
      "aarch64-darwin" = {
        url = "${base}-macos-arm64.tar.gz";
        hash = "sha256-dkBcdVbxolK8xXYaOHot0s9FxGmfhMNAEoZqo+2LRfk=";
      };
    }."${stdenvNoCC.hostPlatform.system}" or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
    ln -s $out/dart-sass-embedded $out/bin/dart-sass-embedded
  '';

  meta = with lib; {
    description = "A wrapper for Dart Sass that implements the compiler side of the Embedded Sass protocol";
    homepage = "https://github.com/sass/dart-sass-embedded";
    changelog = "https://github.com/sass/dart-sass-embedded/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
