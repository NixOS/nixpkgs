{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "rlwrap-0.42";

  src = fetchurl {
    url = "http://utopia.knoware.nl/~hlub/uck/rlwrap/${name}.tar.gz";
    sha256 = "0i3yz303wscrysyzpdq04h4nrl9ajz9dbwi80risdl5rkm3dhw2s";
  };

  buildInputs = [ readline ];

  # Be high-bit-friendly
  preBuild = ''
    sed -i src/readline.c -e "s@[*]p [<] ' '@(*p >= 0) \\&\\& (*p < ' ')@"
  '';

  meta = {
    description = "Readline wrapper for console programs";
    homepage = http://utopia.knoware.nl/~hlub/uck/rlwrap/;
    license = stdenv.lib.licenses.gpl2Plus;
    platform = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
