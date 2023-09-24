{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "1.2.3";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Ppsz3hDG6sEf6LJ2WdbTdJ8Gi53f0YmvaUU8TOfVMz4=";
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
