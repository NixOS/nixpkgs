{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pdnsd-1.2.8-par";

  src = fetchurl {
    url = http://www.phys.uu.nl/~rombouts/pdnsd/releases/pdnsd-1.2.8-par.tar.gz;
    sha256 = "0ki4xkklc5lqs2qfmww63dc2zax48x8acfw661206ps4kvhasg2z";
  };

  patchPhase = ''
    sed -i 's/.*(cachedir).*/:/' Makefile.in
  '';

  meta = { 
    description = "Permanent DNS caching";
    homepage = http://www.phys.uu.nl/~rombouts/pdnsd.html;
    license = "GPLv3+";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
