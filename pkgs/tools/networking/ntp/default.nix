{ stdenv, fetchurl, autoreconfHook, libcap ? null, openssl ? null }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p4";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "1fgxbhv0wyiivi6kh5zpzrd0yqmc48z7d3zmjspw9lj84mbn2s8d";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-ignore-dns-errors"
  ] ++ stdenv.lib.optional (libcap != null) "--enable-linuxcaps";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libcap openssl ];

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
