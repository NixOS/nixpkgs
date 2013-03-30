{ stdenv, fetchurl, pam }:

stdenv.mkDerivation {
  name = "otpw-1.3";

  src = fetchurl {
    url = ttp://www.cl.cam.ac.uk/~mgk25/download/otpw-1.3.tar.gz;
    sha256 = "1k3hc7xbxz6hkc55kvddi3cibafwf93ivn58sy1l888d3l5dwmrk";
  };

  patchPhase = ''
    sed -i 's/^CFLAGS.*/CFLAGS=-O2 -fPIC/' Makefile
  '';

  installPhase = ''
    ensureDir $out/bin $out/lib/security $out/share/man/man{1,8}
    cp pam_*.so $out/lib/security
    cp otpw-gen $out/bin
    cp *.1 $out/share/man/man1
    cp *.8 $out/share/man/man8
  '';

  buildInputs = [ pam ];

  meta = {
    homepage = http://www.cl.cam.ac.uk/~mgk25/otpw.html;
    description = "A one-time password login package";
    license = "GPLv2+";
  };
}
