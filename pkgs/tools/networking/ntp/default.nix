{ stdenv, lib, fetchurl, openssl, perl, libcap ? null, libseccomp ? null }:

assert stdenv.isLinux -> libcap != null;
assert stdenv.isLinux -> libseccomp != null;

let
  withSeccomp = stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64);
in

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p9";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "0whbyf82lrczbri4adbsa4hg1ppfa6c7qcj7nhjwdfp1g1vjh95p";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl-libdir=${openssl.out}/lib"
    "--with-openssl-incdir=${openssl.dev}/include"
    "--enable-ignore-dns-errors"
  ] ++ stdenv.lib.optional stdenv.isLinux "--enable-linuxcaps"
    ++ stdenv.lib.optional withSeccomp "--enable-libseccomp";

  buildInputs = [ libcap openssl perl ] ++ lib.optional withSeccomp libseccomp;

  hardeningEnable = [ "pie" ];

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
