{ lib, stdenv, fetchurl, pkg-config, glib, libuuid, popt, elfutils }:

stdenv.mkDerivation rec {
  pname = "babeltrace";
  version = "1.5.8";

  src = fetchurl {
    url = "https://www.efficios.com/files/babeltrace/${pname}-${version}.tar.bz2";
    sha256 = "1hkg3phnamxfrhwzmiiirbhdgckzfkqwhajl0lmr1wfps7j47wcz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libuuid popt elfutils ];

  meta = with lib; {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = "https://www.efficios.com/babeltrace";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
