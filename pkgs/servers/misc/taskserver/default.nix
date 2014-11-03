{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskserver-${version}";
  version = "1.0.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/taskd-${version}.tar.gz";
    sha256 = "162ef1eec48f8145870ef0dbe0121b78a6da99815bc18af77de07fbb0abe02d0";
  };

  nativeBuildInputs = [ cmake libuuid gnutls ];

  meta = {
    description = "Server for synchronising Taskwarrior clients";
    homepage = http://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
