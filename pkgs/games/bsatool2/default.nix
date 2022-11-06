{ stdenv, lib, fetchFromGitLab, lz4, openssl, argparse, zstr, zlib, cmake }:

stdenv.mkDerivation rec {
  pname = "bsatool2";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "bmwinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3t/82b6hc8P+C5Dk1YPiMBIIMGO3wHXkhC5ZqgkJQq8=";
  };

  patches = [ ./local_deps.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lz4 openssl argparse zstr zlib ];

  checkPhase = "bsatool2 --help";

  meta = with lib; {
    description = "A version of OpenMW's bsatool which supports the creation of bsa files from the later Bethesda games.";
    homepage = "https://gitlab.com/bmwinger/bsatool2";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
