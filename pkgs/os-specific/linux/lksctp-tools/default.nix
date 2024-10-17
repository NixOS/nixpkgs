{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "lksctp-tools";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "sctp";
    repo = "lksctp-tools";
    rev = "v${version}";
    hash = "sha256-h+wMrnx+u/4feNjZr2Gc+y6/80qJ8IVXsrDvHyixMxo=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools";
    homepage = "https://github.com/sctp/lksctp-tools/wiki";
    license = with licenses; [ gpl2Plus lgpl21 ]; # library is lgpl21
    platforms = platforms.linux;
  };
}
