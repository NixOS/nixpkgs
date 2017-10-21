{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "tie-${version}";
  version = "2.4";

  src = fetchurl {
    url = "http://mirrors.ctan.org/web/tie/${name}.tar.gz";
    sha256 = "1m5952kdfffiz33p1jw0wv7dh272mmw28mpxw9v7lkb352zv4xsj";
  };

  buildPhase = ''
    cc tie.c -o tie
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tie $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ctan.org/tex-archive/web/tie;
    description = "Allow multiple web change files";
    platforms = with platforms; unix;
    maintainers = with maintainers; [ vrthra ];
  };
}
