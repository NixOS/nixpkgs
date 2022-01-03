{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, libsodium
, iproute2
}:

stdenv.mkDerivation rec {
  pname = "glorytun";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "angt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1qHvr/tlPyWTInglZHUwpldpXOYeAL5q78t97Cav5CQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libsodium iproute2 ];

  meta = with lib; {
    description = "Multipath UDP tunnel";
    homepage = "https://github.com/angt/glorytun";
    license = licenses.bsd2;
    maintainers = with maintainers; [ georgyo ];
  };
}
