{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "rlwrap-0.41";

  src = fetchurl {
    url = "http://utopia.knoware.nl/~hlub/uck/rlwrap/${name}.tar.gz";
    sha256 = "02n22yy9wgz1cj59is17j0my17y7146ghkng381yxx4dnr3pcj9l";
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
