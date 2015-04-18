{ stdenv, fetchurl, autoreconfHook, libcap ? null }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p2";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "0ccv9kh5asxpk7bjn73vwrqimbkbfl743bgx0km47bfajl7bqs8d";
  };

  configureFlags = stdenv.lib.optional (libcap != null) "--enable-linuxcaps";

  buildInputs = [ autoreconfHook libcap ];

  postInstall = "rm -rf $out/share/doc";

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
