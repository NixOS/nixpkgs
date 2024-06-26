{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "sqlcheck";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jarulraj";
    repo = "sqlcheck";
    rev = "v${version}";
    sha256 = "sha256-rGqCtEO2K+OT44nYU93mF1bJ07id+ixPkRSC8DcO6rY=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/jarulraj/sqlcheck/pull/62
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/jarulraj/sqlcheck/commit/ca131db13b860cf1d9194a1c7f7112f28f49acca.patch";
      hash = "sha256-uoF7rYvjdIUu82JCLXq/UGswgwM6JCpmABP4ItWjDe4=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Automatically identify anti-patterns in SQL queries";
    mainProgram = "sqlcheck";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
