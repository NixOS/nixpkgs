{ lib, stdenv, fetchurl, qt4, qmake4Hook }:

stdenv.mkDerivation rec {
  pname = "valkyrie";
  version = "2.0.0";

  src = fetchurl {
    url = "https://valgrind.org/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0hwvsncf62mdkahwj9c8hpmm94c1wr5jn89370k6rj894kxry2x7";
  };

  patchPhase = ''
    sed -i '1s;^;#include <unistd.h>\n;' src/objects/tool_object.cpp
    sed -i '1s;^;#include <unistd.h>\n;' src/utils/vk_config.cpp
    sed -i '1s;^;#include <sys/types.h>\n;' src/utils/vk_config.cpp
    sed -i '1s;^;#include <unistd.h>\n;' src/utils/vk_utils.cpp
    sed -i '1s;^;#include <sys/types.h>\n;' src/utils/vk_utils.cpp
  '';

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ qmake4Hook ];

  meta = with lib; {
    homepage = "http://www.valgrind.org/";
    description = "Qt4-based GUI for the Valgrind 3.6.x series";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
