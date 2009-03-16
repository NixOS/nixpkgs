{stdenv, fetchurl, SDL}:

stdenv.mkDerivation rec { 
  name = "dosbox-0.72";
  
  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "0ydck7jgvdwnpxakg2y83dmk2dnwx146cgidbmdn7h75y7cxfiqp";
  };
  
  buildInputs = [SDL];

  meta = {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
  };
}
