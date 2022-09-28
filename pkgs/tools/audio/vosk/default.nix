{ lib, callPackage, stdenv, fetchFromGitHub, openblas, libf2c }:
let
  # It requires a special fork that needs to be built differently than how kaldi gets built in nixpkgs.
  kaldi = callPackage ./kaldi.nix { };
in
stdenv.mkDerivation rec {
  pname = "vosk-api";
  version = "0.3.43";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SbCZx+G5q/W7CBVbmGZYf2ubhUJXtSTzaFAwQEJEt3Y=";
  };

  sourceRoot = "source/src";

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-I$(KALDI_ROOT)/src' '-I${kaldi.src}/src' \
      --replace '-I$(OPENFST_ROOT)/include' '-I${kaldi.openfst.src}/src/include'
  '';

  buildInputs = [ openblas kaldi kaldi.openfst libf2c ];

  makeFlags = [
    "KALDI_ROOT=${kaldi}"
    "OPENBLAS_ROOT=${openblas}"
    "USE_SHARED=1"
    "EXT=${let ext = stdenv.hostPlatform.extensions.sharedLibrary; in lib.substring 1 (lib.stringLength ext - 1) ext}"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D libvosk${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libvosk${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

  passthru = {
    models = callPackage ./models.nix { };
  };

  meta = with lib; {
    homepage = "https://alphacephei.com/vosk/";
    description = "Offline speech recognition API";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
