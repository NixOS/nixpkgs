{stdenv, fetchurl, flex}:

stdenv.mkDerivation {
  name = "detox-1.2.0";

  src = fetchurl {
    url = mirror://sourceforge/detox/1.2.0/detox-1.2.0.tar.gz;
    sha256 = "02cfkf3yhw64xg8mksln8w24gdwgm2x9g3vps7gn6jbjbfd8mh45";
  };

  buildInputs = [flex];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = http://detox.sourceforge.net/;
    description = "Utility designed to clean up filenames";
    longDescription = ''
      Detox is a utility designed to clean up filenames. It replaces
      difficult to work with characters, such as spaces, with standard
      equivalents. It will also clean up filenames with UTF-8 or Latin-1
      (or CP-1252) characters in them.
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds ];
  };
}
