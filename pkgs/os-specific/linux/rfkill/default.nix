{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rfkill-0.4";
  
  src = fetchurl {
    url = "http://wireless.kernel.org/download/rfkill/${name}.tar.bz2";
    sha256 = "1hb884vgyldci648azbx17w83gzynn0svrmfjgh3c2jzga1f846a";
  };

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://wireless.kernel.org/en/users/Documentation/rfkill;
    description = "A tool to query, enable and disable wireless devices";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
