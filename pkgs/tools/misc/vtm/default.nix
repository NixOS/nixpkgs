{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "vtm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "netxs-group";
    repo = "vtm";
    rev = "v${version}";
    sha256 = "sha256-Ty7DC4ap2F+mPzr1xaL8XeLSjQaQQVX0oGAcPpkoag4=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "../src" ];

  meta = {
    homepage = "https://vtm.netxs.online/";
    description = "Terminal multiplexer with window manager and session sharing";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ahuzik ];
  };
}
