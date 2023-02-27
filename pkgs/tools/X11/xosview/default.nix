{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXpm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosview";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "hills";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-9Pr7voJiCH7oBziMFRHCWxoyuGdndcdRD2POjiNT7yw=";
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
