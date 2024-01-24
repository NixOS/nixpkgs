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
    x86_64-linux = "sha256-i06Zp176zl7y8P32Hss64QkMc/+vXtkQy/tkOPSX3dc=";
    aarch64-linux = "sha256-HEm3TaLeaws8G73CU9BmxeplQdeF9nQbBSnbctaVhqI=";
    x86_64-darwin = "sha256-mlshpN/4Od4qrXiqIEYo7G84Dtb+tp2nK2VnrRG2rto=";
    aarch64-darwin = "sha256-aJH/vOidj0vbkttGDgelaAC/dMYguQPLjxl+V3pOVzI=";
  }.${system} or (throw "Unsupported system: ${system}");

in stdenv.mkDerivation rec {
  pname = "fermyon-spin";
  version = "2.1.0";

  src = fetchzip {
    url = "https://github.com/fermyon/spin/releases/download/v${version}/spin-v${version}-${platform}.tar.gz";
    stripRoot = false;
    hash = packageHash;
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
