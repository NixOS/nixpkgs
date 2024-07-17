{
  stdenv,
  lib,
  fetchurl,
  gnulib,
}:

stdenv.mkDerivation rec {
  pname = "gnu-pw-mgr";
  version = "2.7.4";
  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gnu-pw-mgr/${pname}-${version}.tar.xz";
    sha256 = "0fhwvsmsqpw0vnivarfg63l8pgwqfv7d5wi6l80jpb41dj6qpjz8";
  };

  buildInputs = [ gnulib ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/gnu-pw-mgr/";
    description = "A password manager designed to make it easy to reconstruct difficult passwords";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ qoelet ];
  };
}
