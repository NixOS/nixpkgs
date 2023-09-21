{lib, stdenv, fetchurl, flex}:

stdenv.mkDerivation rec {
  pname = "detox";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/detox/${version}/detox-${version}.tar.gz";
    sha256 = "02cfkf3yhw64xg8mksln8w24gdwgm2x9g3vps7gn6jbjbfd8mh45";
  };

  buildInputs = [flex];

  hardeningDisable = [ "format" ];

  postInstall = ''
    install -m644 safe.tbl $out/share/detox/
  '';

  meta = with lib; {
    homepage = "https://detox.sourceforge.net/";
    description = "Utility designed to clean up filenames";
    longDescription = ''
      Detox is a utility designed to clean up filenames. It replaces
      difficult to work with characters, such as spaces, with standard
      equivalents. It will also clean up filenames with UTF-8 or Latin-1
      (or CP-1252) characters in them.
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
