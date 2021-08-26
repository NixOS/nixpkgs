{ lib, stdenv, fetchFromGitLab, cmake, nasm }:

stdenv.mkDerivation rec {
  pname = "svt-av1";
  version = "0.8.7";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${version}";
    sha256 = "1xlxb6kn6hqz9dxz0nd905m4i2mwjwq1330rbabwzmg4b66cdslg";
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
      bsd2
      {
        fullName = "Alliance for Open Media Patent License 1.0";
        url = "https://aomedia.org/license/patent-license/";
      }
    ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64; # undefined reference to `cpuinfo_arm_linux_init'
    maintainers = with maintainers; [ chiiruno ];
  };
}
