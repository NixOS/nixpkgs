{ stdenv, lib, fetchurl, openssl, perl, libcap ? null, libseccomp ? null }:

assert stdenv.isLinux -> libcap != null;
assert stdenv.isLinux -> libseccomp != null;

let
  withSeccomp = stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64);
in

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p11";

  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "13i7rp1va29ffjdk08fvsfl6n47zzwsp147zhgb550k8agvkjjpi";
  };

  # The hardcoded list of allowed system calls for seccomp is
  # insufficient for NixOS, add more to make it work (issue #21136).
  patches = [ ./seccomp.patch ];

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

  meta = with stdenv.lib; {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
  };
}
