{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ired-0.4";

  src = fetchurl {
    url = "http://radare.org/get/${name}.tar.gz";
    sha256 = "0wya1ylc6adqg4qw5fi8aspc5d1yr27x9r2vpy133qxzia9qv3mm";
  };
  
  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    description = "Interactive Raw Editor";
    homepage = http://radare.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
