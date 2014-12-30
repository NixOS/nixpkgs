{ stdenv, fetchgit, openssl, nss, nspr, kerberos, gmp, zlib, libpcap, re2 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "JohnTheRipper-${version}";
  version = "8a3e3c1d";
  buildInputs = [ openssl nss nspr kerberos gmp zlib libpcap re2 ];
  NIX_CFLAGS_COMPILE = "-DJOHN_SYSTEMWIDE=1";
  preConfigure = ''cd src'';
  installPhase = ''
    ensureDir $out/share/john/
    ensureDir $out/bin
    cp -R ../run/* $out/share/john
    ln -s $out/share/john/john $out/bin/john
  '';
  src = fetchgit {
    url = https://github.com/magnumripper/JohnTheRipper.git;
    rev = "93f061bc41652c94ae049b52572aac709d18aa4c";
    sha256 = "1rnfi09830n34jcqaxmsam54p4zsq9a49ic2ljh44lahcipympvy";
  };
  meta = {
    description = "John the Ripper password cracker";
    license = licenses.gpl2;
    homepage = https://github.com/magnumripper/JohnTheRipper/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
