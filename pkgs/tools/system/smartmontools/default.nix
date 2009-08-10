{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "smartmontools-5.38";
  
  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${name}.tar.gz";
    sha256 = "1s1i5y5n3jx681y03jj459yy4ijaq564z8bp2cgqb97wl4h762dj";
  };

  meta = {
    description = "Tools for monitoring the health of hard drivers";
    homepage = http://smartmontools.sourceforge.net/;
    license = "GPL";
  };
}
