{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ascii-${version}";
  version = "3.15";

  src = fetchurl {
    url = "http://www.catb.org/~esr/ascii/${name}.tar.gz";
    sha256 = "0pzzfljg2ijnnys3fzj3f2p288sl5cgk83a2mpcm679pcj5xpqdc";
  };

  prePatch = ''
    sed -i -e "s|^PREFIX = .*|PREFIX = $out|" Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "Interactive ASCII name and synonym chart";
    homepage = http://www.catb.org/~esr/ascii/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
