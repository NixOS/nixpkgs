{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-WNSpV3KhALzl35R1hR0QBzm8atdnbfsB5xh3h4MZBqA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gnutls libite libconfuse ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/projects/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
