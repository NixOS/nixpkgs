{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, gcc-unwrapped
, zlib
}:

let
  system = stdenv.hostPlatform.system;

  platform = {
    x86_64-linux = "linux-amd64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "macos-amd64";
    aarch64-darwin = "macos-aarch64";
  }.${system} or (throw "Unsupported system: ${system}");

  packageHash = {
    x86_64-linux = "sha256-Fp1h1X5UFOHLqgaAcXXl3oSioCMVLJLaOURHd3uu8sA=";
    aarch64-linux = "sha256-F6/h98qZvzImuxPOMYr1cGWBjr1qWGvoYztvZzw2GRg=";
    x86_64-darwin = "sha256-WegiHPHi9Qw4PPTEB2a9AdIgMlyOzzSpTRdJH43IEjM=";
    aarch64-darwin = "sha256-BJER3Fp4AItqtLNYh6pH/tNB98H3iTARr3fKyTXGcP8=";
  }.${system} or (throw "Unsupported system: ${system}");

in stdenv.mkDerivation rec {
  pname = "fermyon-spin";
  version = "1.2.1";

  src = fetchzip {
    url = "https://github.com/fermyon/spin/releases/download/v${version}/spin-v${version}-${platform}.tar.gz";
    stripRoot = false;
    sha256 = packageHash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    gcc-unwrapped.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src/* $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Framework for building, deploying, and running fast, secure, and composable cloud microservices with WebAssembly.";
    homepage = "https://github.com/fermyon/spin";
    license = with licenses; [ asl20 ];
    mainProgram = "spin";
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
