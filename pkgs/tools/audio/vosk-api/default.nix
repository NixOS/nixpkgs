{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, kaldi
, openblas
, python3
, lib
}:

stdenv.mkDerivation rec {
  name = "vosk-api";
  version = "0.3.43";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "vosk-api";
    rev = "v${version}";
    sha256 = "SbCZx+G5q/W7CBVbmGZYf2ubhUJXtSTzaFAwQEJEt3Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    (kaldi.overrideAttrs (attrs: {
      patches = attrs.patches or [ ] ++ [
        # Vosk patches: https://github.com/kaldi-asr/kaldi/compare/master...alphacep:kaldi:vosk
        # https://github.com/alphacep/vosk-api/issues/1082
        (fetchpatch {
          url = "https://github.com/kaldi-asr/kaldi/commit/1612ee9afa41e141061e53615fffa2a7cfdf94ac.patch";
          sha256 = "owqmOIhh4ylR2mOBc9fxV0yrMVYtV4bobnvl2Quis2A=";
        })
        (fetchpatch {
          url = "https://github.com/kaldi-asr/kaldi/commit/8f96991720beb0685fba15ffcea9ac89d33b8d23.patch";
          sha256 = "IyFwezIdpfvvSRThJacb4spy9EZVDsRzvJlmglB/caw=";
        })
      ];
    }))
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
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
