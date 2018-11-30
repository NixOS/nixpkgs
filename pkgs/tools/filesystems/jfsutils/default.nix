{ stdenv, fetchurl, libuuid, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jfsutils-1.1.15";

  src = fetchurl {
    url = "http://jfs.sourceforge.net/project/pub/${name}.tar.gz";
    sha256 = "0kbsy2sk1jv4m82rxyl25gwrlkzvl3hzdga9gshkxkhm83v1aji4";
  };

  patches = [
    ./types.patch
    ./hardening-format.patch
    # required for cross-compilation
    ./ar-fix.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid ];

  meta = with stdenv.lib; {
    description = "IBM JFS utilities";
    homepage = http://jfs.sourceforge.net;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
