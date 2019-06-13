{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "6.4.2";
  name = "multitail-${version}";

  src = fetchurl {
    url = "https://www.vanheusden.com/multitail/${name}.tgz";
    sha256 = "1zd1r89xkxngl1pdrvsc877838nwkfqkbcgfqm3vglwalxc587dg";
  };

  buildInputs = [ ncurses ];

  makeFlags = stdenv.lib.optionalString stdenv.isDarwin "-f makefile.macosx";

  installPhase = ''
    mkdir -p $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = http://www.vanheusden.com/multitail/;
    description = "tail on Steroids";
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
