{ lib
, stdenv
, fetchurl
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

  # TODO: It'd be nice to write an update script that would update all of these
  # hashes together.
  packageHash = {
    x86_64-linux = "sha256-gYHIfvgofT9tKYCchZoRYvioLCtp2wfaOtuVWxTyujM=";
    aarch64-linux = "sha256-zW+aeUc67pa6mQQkfazShHKAvGeucswLK1eRCxzXOJM=";
    x86_64-darwin = "sha256-ph+SrrxOIyG9rRS098duhvDFiNGuh0o2uemm++J+zKw=";
    aarch64-darwin = "sha256-eOpRaivRhk841/TCxC4ygw27UrPkqQCMH2mme2qo8V8=";
  }.${system} or (throw "Unsupported system: ${system}");

in stdenv.mkDerivation rec {
  pname = "fermyon-spin";
  version = "2.5.1";

  # Use fetchurl rather than fetchzip as these tarballs are built by the project
  # and not by GitHub (and thus are stable) - this simplifies the update script
  # by allowing it to use the output of `nix store prefetch-file`.
  src = fetchurl {
    url = "https://github.com/fermyon/spin/releases/download/v${version}/spin-v${version}-${platform}.tar.gz";
    hash = packageHash;
  };

  sourceRoot = ".";

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
    cp ./spin $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Framework for building, deploying, and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://github.com/fermyon/spin";
    license = with licenses; [ asl20 ];
    mainProgram = "spin";
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
