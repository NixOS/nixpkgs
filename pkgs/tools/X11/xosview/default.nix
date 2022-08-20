{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosview";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "hills";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-CoBVFTCpvZkIe/g+17JNV1y0G9K+t+p3EE9C5kuBe2k=";
  };

  dontConfigure = true;

  buildInputs = [
    libX11
    libXpm
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PLATFORM=linux"
  ];

  meta = with lib; {
    homepage = "http://www.pogo.org.uk/~mark/xosview/";
    description = "A classic system monitoring tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
})
# TODO: generalize to other platforms
