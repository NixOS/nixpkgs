{ stdenv
, fetchFromGitHub
, fetchpatch2
, cmake
, kaldi
, openblas
, python3
, lib
}:

let
  tweakedDependencies = {
    kaldi = kaldi.overrideAttrs (attrs: {
      patches = attrs.patches or [ ] ++ [
        # Vosk patches: https://github.com/kaldi-asr/kaldi/compare/master...alphacep:kaldi:vosk
        # https://github.com/alphacep/vosk-api/issues/1082
        # Expose raw lattice
        (fetchpatch2 {
          url = "https://github.com/kaldi-asr/kaldi/commit/dd629c862e7ff45ed9fe79c38dcb7c793549dc03.patch";
          hash = "sha256-Wwn/FY7pi0sndt3esbFtU8k+MoHUluEVZ5jEq1/b7o8=";
        })
        # Allow alignment of the partial lattice without warnings
        (fetchpatch2 {
          url = "https://github.com/kaldi-asr/kaldi/commit/98155d8ae0a7f6b2f5d5ed33c07927aaefe96622.patch";
          hash = "sha256-uWGKQeSNkvKdndc8jcbnOhxtzt2eiZKLluQPrtN5wf4=";
        })
      ];
    });
  };
in
let
  # Shadow the original kaldi to prevent accidental use.
  inherit (tweakedDependencies) kaldi;
in
stdenv.mkDerivation rec {
  name = "vosk-api";
  version = "0.3.45";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "vosk-api";
    rev = "v${version}";
    hash = "sha256-sa+rUJP0JvZo7YOFrWDEAuySlQJstOBnldz/LMiu/pk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    kaldi
    openblas
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=on"
  ];

  passthru = {
    tests = {
      python = python3.pkgs.vosk-python;
    };
  };

  meta = with lib; {
    description = "Offline speech recognition API";
    homepage = "https://github.com/alphacep/vosk-api";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
