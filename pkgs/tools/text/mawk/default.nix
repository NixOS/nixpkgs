{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20230203";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/mawk-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/mawk-${version}.tgz"
    ];
    sha256 = "sha256-bbejKsecURB60xpAfU+SxrhC3eL2inUztOe3sD6JAL4=";
  };

  meta = with lib; {
    description = "Interpreter for the AWK Programming Language";
    homepage = "https://invisible-island.net/mawk/mawk.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
