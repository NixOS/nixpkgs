{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
}:

stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "nqptp";

  src = fetchFromGitHub {
    owner = "mikebrady";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JfgJXyUCUUrydHHUHSLvtJ6KfFS8eKVEzCW5AdzakI0=";
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
