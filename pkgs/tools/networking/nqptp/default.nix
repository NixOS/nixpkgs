{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "unstable-2022-09-12";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = pname;
    rev = "476e69697d2ec1a28d399432aed23c580e3e570a";
    hash = "sha256-UPUYEX5YUl//OcsBKuGgKLaAMzn2F+ksNRQJ3/pkbKc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/mikebrady/nqptp";
    description = "Daemon and companion application to Shairport Sync that monitors timing data from any PTP clocks";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jordanisaacs ];
    platforms = platforms.linux ++ platforms.freebsd;
  };
}
