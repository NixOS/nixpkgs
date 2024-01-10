{ lib
, fetchzip
, stdenv
, buildFHSEnv
}:

let
  version = "1.9.0";
  srcs = {
    x86_64-linux = fetchzip {
      url = "https://github.com/CQLabs/homebrew-dcm/releases/download/${version}/dcm-linux-x64-release.zip";
      hash = "sha256-03++l8jDvvtg2hdSgQB6G89ca3bqzqSLair/9hRE8wc=";
    };
    x86_64-darwin = fetchzip {
      url = "https://github.com/CQLabs/homebrew-dcm/releases/download/${version}/dcm-macos-x64-release.zip";
      hash = "sha256-tNUfhgKEH0uVVYCFQ6rJpMhujvod9SOzkih4BMGNAyQ=";
    };
    aarch64-darwin = fetchzip {
      url = "https://github.com/CQLabs/homebrew-dcm/releases/download/${version}/dcm-macos-arm-release.zip";
      hash = "sha256-LOm5grxP1s83rizsPxCB7Cuo1OQUFNqew/e0bxYGaGM=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dcm-unwrapped = stdenv.mkDerivation {
    pname = "dcm-unwrapped";
    inherit src version;
    installPhase = ''
      install -m755 -D dcm $out/bin/dcm
    '';
    dontFixup = true;
  };
in
buildFHSEnv {
  name = "dcm";
  targetPkgs = pkgs: [ dcm-unwrapped ];
  runScript = "dcm";

  meta = {
    description = "static code analysis tool for dart";
    homepage = "https://dcm.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.NANASHI0X74 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
