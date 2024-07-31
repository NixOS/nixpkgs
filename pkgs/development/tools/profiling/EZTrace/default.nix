{ lib,
  stdenv,
  fetchFromGitLab,
  gfortran,
  libelf,
  libiberty,
  zlib,
  # Once https://gitlab.com/eztrace/eztrace/-/issues/41
  # is released we can switch to latest binutils.
  libbfd_2_38,
  libopcodes_2_38,
  autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "EZTrace";
  version = "1.1-11";

  src = fetchFromGitLab {
    owner = "eztrace";
    repo = "eztrace";
    rev = "eztrace-${version}";
    hash = "sha256-A6HMr4ib5Ka1lTbbTQOdq3kIdCoN/CwAKRdXdv9wpfU=";
  };

  nativeBuildInputs = [ gfortran autoreconfHook ];
  buildInputs = [ libelf libiberty zlib libbfd_2_38 libopcodes_2_38 ];

  meta = with lib; {
    description = "Tool that aims at generating automatically execution trace from HPC programs";
    license = licenses.cecill-b;
    maintainers = [ ];
  };
}
