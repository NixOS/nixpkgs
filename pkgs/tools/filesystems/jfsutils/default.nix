{ stdenv, fetchurl, libuuid }:

stdenv.mkDerivation rec {
  name = "jfsutils-1.1.15";

  src = fetchurl {
    url = "http://jfs.sourceforge.net/project/pub/${name}.tar.gz";
    sha256 = "0kbsy2sk1jv4m82rxyl25gwrlkzvl3hzdga9gshkxkhm83v1aji4";
  };

  patches = [ ./types.patch ./hardening-format.patch ];

  buildInputs = [ libuuid ];

  meta = {
    description = "IBM JFS utilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
