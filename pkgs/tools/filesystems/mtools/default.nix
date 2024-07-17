{
  lib,
  stdenv,
  fetchurl,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "mtools";
  version = "4.0.44";

  src = fetchurl {
    url = "mirror://gnu/mtools/${pname}-${version}.tar.bz2";
    hash = "sha256-N9xN8CJTPD1LLsHHiXPCfH6LWFN0wtRqtkxqPbMe3bg=";
  };

  patches = lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = lib.optional stdenv.isDarwin "--without-x";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  doCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mtools/";
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
