{ stdenv, lib, fetchzip, which, expat, curl }:
stdenv.mkDerivation rec {
  pname = "wfdb";
  version = "10.6.2";

  src = fetchzip {
    url = "https://physionet.org/static/published-projects/wfdb/wfdb-software-package-${version}.zip";
    sha256 = "sha256-ZNG1hOABdx6KEao5/7gd3nnVj5udfcS/BQullCn03QA=";
  };

  nativeBuildInputs = [
    which # Used by ./configure to find build-time dependencies
  ];

  buildInputs = [
    # Optional dependencies
    expat
    curl
  ];

  # Avoid tests that need the network
  WFDB_NO_NET_CHECK = 1;
  # Library checks are run during build phase already. doCheck adds the application tests
  doCheck = true;
  # Checks need the library and application binaries installed
  preCheck = ''
    make install
  '';

  meta = with lib; {
    description = "Application and library for reading and writing file formats used by PhysioBank database";
    longDescription = ''
      This is a set of functions (subroutines) for reading and writing files in
      the formats used by PhysioBank databases (among others). The WFDB library
      is LGPLed, and can be used by programs written in ANSI/ISO C, K&R C, C++,
      or Fortran, running under any operating system for which an ANSI/ISO or
      K&R C compiler is available, including all versions of Unix, MS-DOS,
      MS-Windows, the Macintosh OS, and VMS.
    '';
    homepage = "https://physionet.org/content/wfdb";
    # Library as LGPL2 and application as GPLv2 or later
    license = [ licenses.lgpl2 licenses.gpl2Plus ];
    maintainers = [ ];
    platforms = platforms.all;
  };
}
