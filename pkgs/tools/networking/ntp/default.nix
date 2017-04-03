{ stdenv, fetchurl, autoreconfHook, perl, libcap ? null, openssl ? null }:

assert stdenv.isLinux -> libcap != null;

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p10";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "17xrk7gxrl3hgg0i73n8qm53knyh01lf0f3l1zx9x6r1cip3dlnx";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl-libdir=${openssl.out}/lib"
    "--with-openssl-incdir=${openssl.dev}/include"
    "--enable-ignore-dns-errors"
  ] ++ stdenv.lib.optional (libcap != null) "--enable-linuxcaps";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libcap openssl perl ];

  hardeningEnable = [ "pie" ];

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
  };
}
