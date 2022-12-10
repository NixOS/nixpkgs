{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20200120";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/mawk-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/mawk-${version}.tgz"
    ];
    sha256 = "0dw2icf8bnqd9y0clfd9pkcxz4b2phdihwci13z914mf3wgcvm3z";
  };

  meta = with lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = "https://invisible-island.net/mawk/mawk.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
