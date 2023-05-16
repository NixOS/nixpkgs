{ lib
, stdenv
, fetchFromGitHub
, cmake
<<<<<<< HEAD
, pkg-config
, python3
=======
, fetchpatch
, pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "osslsigncode";
<<<<<<< HEAD
  version = "2.6";
=======
  version = "2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mtrojnar";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Lt99RO/pTEtksIuulkKTm48+1xUKZOHrnlbDZGi3VWk=";
  };

  nativeBuildInputs = [ cmake pkg-config python3 ];
=======
    sha256 = "sha256-33uT9PFD1YEIMzifZkpbl2EAoC98IsM72K4rRjDfh8g=";
  };

  patches = [
    # Cygwin patch is prereq for Darwin fix applying -- committed to master after 2.5 release
    (fetchpatch {
      url = "https://github.com/mtrojnar/osslsigncode/commit/1c678bf926b78c947b14c46c3ce88e06268c738e.patch";
      sha256 = "sha256-vOBMGIJ3PHJTvmsXRRfAUJRi7P929PcfmrUiRuM0pf4=";
    })
    # Fix build on Darwin when clang not identified as Apple (https://github.com/mtrojnar/osslsigncode/pull/247)
    (fetchpatch {
      url = "https://github.com/charles-dyfis-net/osslsigncode/commit/b2ed89b35c8a26faa7eb6515fecaff3c4c5f7fed.patch";
      sha256 = "sha256-FGKZK/IzHbbkTzSoAtpC75z79d5+qQvvJrjEDY31WJ0=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ curl openssl ];

  meta = with lib; {
    homepage = "https://github.com/mtrojnar/osslsigncode";
    description = "OpenSSL based Authenticode signing for PE/MSI/Java CAB files";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mmahut prusnak ];
    platforms = platforms.all;
  };
}
