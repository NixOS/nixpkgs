{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "ndisc6-1.0.2";

  src = fetchurl {
    url = "http://www.remlab.net/files/ndisc6/archive/${name}.tar.bz2";
    sha256 = "0ynacanjhlib4japqmf7n2c0bv5f2qq6rx2nhk4kmylyrfhcikka";
  };

  buildInputs = [ perl ];

  configureFlags = "--localstatedir=/var";

  installFlags = "localstatedir=$(TMPDIR)";

  meta = {
    homepage = http://www.remlab.net/ndisc6/;
    description = "A small collection of useful tools for IPv6 networking";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
