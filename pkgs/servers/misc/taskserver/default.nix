{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskserver-${version}";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/taskd-${version}.tar.gz";
    sha256 = "1d110q9vw8g5syzihxymik7hd27z1592wkpz55kya6lphzk8i13v";
  };

  nativeBuildInputs = [ cmake libuuid gnutls ];

  meta = {
    description = "Server for synchronising Taskwarrior clients";
    homepage = http://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
