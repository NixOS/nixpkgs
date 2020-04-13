{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ascii";
  version = "3.18";

  src = fetchurl {
    url = "http://www.catb.org/~esr/ascii/${pname}-${version}.tar.gz";
    sha256 = "0b87vy06s8s3a8q70pqavsbk4m4ff034sdml2xxa6qfsykaj513j";
  };

  prePatch = ''
    sed -i -e "s|^PREFIX = .*|PREFIX = $out|" Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  meta = with stdenv.lib; {
    description = "Interactive ASCII name and synonym chart";
    homepage = "http://www.catb.org/~esr/ascii/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
