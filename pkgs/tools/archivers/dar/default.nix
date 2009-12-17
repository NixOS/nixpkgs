{stdenv, fetchurl, zlib, bzip2, openssl}:

stdenv.mkDerivation rec {
  name = "dar-2.3.9";
  src = fetchurl {
    url = "mirror://sourceforge/dar/dar-2.3.9.tar.gz";
    sha256 = "037ak6wckqyn52000m8bapgnf70rw776dl3s61i9bdq548slq6yc";
  };

  buildInputs = [zlib bzip2 openssl];

  meta = {
	  homepage = http://dar.linux.free.fr/;
	  description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
