{ lib,
  stdenv,
  fetchFromGitLab,
  gfortran,
  libelf,
  libiberty,
  zlib,
  libbfd,
  libopcodes,
  buildPackages,
  autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "EZTrace";
  version = "1.1-11";

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    rev = "eztrace-${version}";
    sha256 = "sha256-A6HMr4ib5Ka1lTbbTQOdq3kIdCoN/CwAKRdXdv9wpfU=";
  };

  nativeBuildInputs = [ gfortran autoreconfHook ];
  buildInputs = [ libelf libiberty zlib libbfd libopcodes ];

  meta = with lib; {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = licenses.cecill-b;
    maintainers = with maintainers; [ ];
  };
}
