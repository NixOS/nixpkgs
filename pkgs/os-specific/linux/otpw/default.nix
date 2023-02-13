{ lib, stdenv, fetchurl, pam, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "otpw";
  version = "1.3";

  src = fetchurl {
    url = "https://www.cl.cam.ac.uk/~mgk25/download/otpw-${version}.tar.gz";
    sha256 = "1k3hc7xbxz6hkc55kvddi3cibafwf93ivn58sy1l888d3l5dwmrk";
  };

  patchPhase = ''
    sed -i 's/^CFLAGS.*/CFLAGS=-O2 -fPIC/' Makefile
    sed -i -e 's,PATH=.*;,,' conf.h
    sed -i -e '/ENTROPY_ENV/d' otpw-gen.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/security $out/share/man/man{1,8}
    cp pam_*.so $out/lib/security
    cp otpw-gen $out/bin
    cp *.1 $out/share/man/man1
    cp *.8 $out/share/man/man8
  '';

  buildInputs = [ pam libxcrypt ];

  hardeningDisable = [ "stackprotector" ];

  meta = {
    homepage = "http://www.cl.cam.ac.uk/~mgk25/otpw.html";
    description = "A one-time password login package";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
