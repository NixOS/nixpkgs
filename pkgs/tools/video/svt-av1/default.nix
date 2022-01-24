{ lib, stdenv, fetchFromGitLab, cmake, nasm }:

stdenv.mkDerivation rec {
  pname = "svt-av1";
  version = "0.9.0";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${version}";
    sha256 = "sha256-kmFyJ5b0EiesWUN71rbULF2cQt2pICF0P/MeZ+h7W9U=";
  };

  nativeBuildInputs = [ cmake nasm ];

  meta = with lib; {
    description = "AV1-compliant encoder/decoder library core";
    longDescription = ''
      The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an
      AV1-compliant encoder/decoder library core. The SVT-AV1 encoder
      development is a work-in-progress targeting performance levels applicable
      to both VOD and Live encoding / transcoding video applications. The
      SVT-AV1 decoder implementation is targeting future codec research
      activities.
    '';
    inherit (src.meta) homepage;
    changelog = "https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      aom
      bsd2
      bsd3
    ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64; # undefined reference to `cpuinfo_arm_linux_init'
    maintainers = with maintainers; [ chiiruno ];
  };
}
