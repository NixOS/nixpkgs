{ stdenv, fetchurl, pam }:

stdenv.mkDerivation rec {
  name = "otpw-1.3";

  src = fetchurl {
    url = "http://www.cl.cam.ac.uk/~mgk25/download/${name}.tar.gz";
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

  buildInputs = [ pam ];

  hardeningDisable = [ "stackprotector" ];

  meta = {
    homepage = http://www.cl.cam.ac.uk/~mgk25/otpw.html;
    description = "A one-time password login package";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
