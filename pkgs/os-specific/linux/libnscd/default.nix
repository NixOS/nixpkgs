{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libnscd-2.0.2";

  src = fetchurl {
    url = http://ftp.suse.com/pub/people/kukuk/libnscd/libnscd-2.0.2.tar.bz2;
    sha256 = "0nxhwy42x44jlpdb5xq1prbvfjmds4hplmwv3687z0c4r9rn506l";
  };

  patches = [ ./libnscd-2.0.2-glibc-2.26.patch ];

  NIX_CFLAGS_COMPILE = [ "-Wno-cast-qual" ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
