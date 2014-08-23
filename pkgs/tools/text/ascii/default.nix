{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ascii-${version}";
  version = "3.14";

  src = fetchurl {
    url = "http://www.catb.org/~esr/ascii/${name}.tar.gz";
    sha256 = "1ldwi4cs2d36r1fv3j13cfa8h2pc4yayq5qii91758qqwfzky3kz";
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
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
