{ lib
, stdenv
, fetchFromGitLab
, gitUpdater
, cmake
, nasm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-av1";
  version = "1.7.0";

  src = fetchFromGitLab {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WKc0DNwpA9smMS3e/GDkk77FUkohwaPMgcXgji14CIw=";
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  cmakeFlags = [
    "-DSVT_AV1_LTO=ON"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://gitlab.com/AOMediaCodec/SVT-AV1";
    description = "AV1-compliant encoder/decoder library core";

    longDescription = ''
      The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an
      AV1-compliant encoder/decoder library core. The SVT-AV1 encoder
      development is a work-in-progress targeting performance levels applicable
      to both VOD and Live encoding / transcoding video applications. The
      SVT-AV1 decoder implementation is targeting future codec research
      activities.
    '';

    changelog = "https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with licenses; [ aom bsd3 ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.unix;
  };
})
