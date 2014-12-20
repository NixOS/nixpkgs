{ stdenv, fetchurl, bison, flex }:

stdenv.mkDerivation rec {
  name = "olsrd-0.6.6.1";

  src = fetchurl {
    url = "http://www.olsr.org/releases/0.6/${name}.tar.bz2";
    sha256 = "1fphbh9x724r83gxxrd13zv487s4svnr9jdy76h4f36xxb15pnp8";
  };

  buildInputs = [ bison flex ];

  preConfigure = ''
    makeFlags="prefix=$out ETCDIR=$out/etc"
  '';

  meta = {
    description = "An adhoc wireless mesh routing daemon";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://olsr.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
