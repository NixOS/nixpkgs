{ stdenv, fetchurl, openssl, nss, nspr, kerberos, gmp, zlib, libpcap, re2 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "john-${version}";
  version = "1.8.0-jumbo-1";

  src = fetchurl {
    url = "http://www.openwall.com/john/j/${name}.tar.xz";
    sha256 = "08q92sfdvkz47rx6qjn7qv57cmlpy7i7rgddapq5384mb413vjds";
  };

  buildInputs = [ openssl nss nspr kerberos gmp zlib libpcap re2 ];

  NIX_CFLAGS_COMPILE = "-DJOHN_SYSTEMWIDE=1";

  preConfigure = "cd src";

  installPhase = ''
    mkdir -p "$out/share/john"
    mkdir -p "$out/bin"
    cp -R ../run/* "$out/share/john"
    ln -s "$out/share/john/john" "$out/bin/john"
  '';

  meta = {
    description = "John the Ripper password cracker";
    license = licenses.gpl2;
    homepage = https://github.com/magnumripper/JohnTheRipper/;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
