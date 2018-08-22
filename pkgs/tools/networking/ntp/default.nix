{ stdenv, lib, fetchurl, openssl, perl, libcap ? null, libseccomp ? null, pps-tools }:

assert stdenv.isLinux -> libcap != null;
assert stdenv.isLinux -> libseccomp != null;

let
  withSeccomp = stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64);
in

stdenv.mkDerivation rec {
  name = "ntp-4.2.8p12";

  src = fetchurl {
    url = "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "0m04ndn0674kcf9x0aggjya07a3hlig2nlzzpwk7vmqka0mj56vh";
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

  buildInputs = [ libcap openssl perl ]
    ++ lib.optional withSeccomp libseccomp
    ++ lib.optional stdenv.isLinux pps-tools;

  hardeningEnable = [ "pie" ];

  postInstall = ''
    rm -rf $out/share/doc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
    license = {
      # very close to isc and bsd2
      url = https://www.eecis.udel.edu/~mills/ntp/html/copyright.html;
    };
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
  };
}
