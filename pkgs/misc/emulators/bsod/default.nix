{lib, stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  pname = "bsod";
  version = "0.1";

  src = fetchurl {
    url = "https://www.vanheusden.com/bsod/bsod-${version}.tgz";
    sha256 = "0hqwacazyq5rhc04j8w8w0j0dgb6ca8k66c9lxf6bsyi6wvbhvmd";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp bsod $out/bin
  '';

  meta = {
    description = "Blue Screen Of Death emulator for Unix";
    longDescription = "
      This program will let you UNIX user experience the authentic
      microsoft windows experience.  Bsod displays the famous windows xp
      blue screen of death on the console.  Errors and drivers causing the
      error are selected randomly from a large set of examples.";
    homepage = "http://www.vanheusden.com/bsod/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.antono ];
  };

}
