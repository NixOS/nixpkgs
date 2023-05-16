{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, ldns
, libck
, nghttp2
, openssl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "dnsperf";
<<<<<<< HEAD
  version = "2.13.1";
=======
  version = "2.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-iNTuLcN9bsBPyXZ8SL96moFaI2pTcEhFey8+4xo9iyk=";
=======
    sha256 = "sha256-vZ2GPrlMHMe2vStjktbyLtXS5SoNzHbNwFi+CL1Z4VQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ldns # optional for DDNS (but cheap anyway)
    libck
    nghttp2
    openssl
  ];

  doCheck = true;

  meta = with lib; {
    description = "Tools for DNS benchmaring";
    homepage = "https://www.dns-oarc.net/tools/dnsperf";
<<<<<<< HEAD
    changelog = "https://github.com/DNS-OARC/dnsperf/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    mainProgram = "dnsperf";
    maintainers = with maintainers; [ vcunat mfrw ];
=======
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vcunat ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
