{ lib, stdenv, fetchFromGitHub, cmake, lksctp-tools, sctpSupport ? true }:

stdenv.mkDerivation (finalAttrs: {
  pname = "cannelloni";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "mguentner";
    repo = "cannelloni";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pAXHo9NCXMFKYcIJogytBiPkQE0nK6chU5TKiDNCKA8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals sctpSupport [ lksctp-tools ];

  cmakeFlags = [
    "-DSCTP_SUPPORT=${lib.boolToString sctpSupport}"
  ];

  meta = with lib; {
    description = "SocketCAN over Ethernet tunnel";
    mainProgram = "cannelloni";
    homepage = "https://github.com/mguentner/cannelloni";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.samw ];
  };
})
