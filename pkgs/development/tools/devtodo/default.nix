{ stdenv, fetchurl, readline, ncurses }:

stdenv.mkDerivation rec {
  name = "devtodo-${version}";
  version = "0.1.20";

  src = fetchurl {
    url = "http://swapoff.org/files/devtodo/${name}.tar.gz";
    sha256 = "029y173njydzlznxmdizrrz4wcky47vqhl87fsb7xjcz9726m71p";
  };

  buildInputs = [ readline ncurses ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://swapoff.org/devtodo1.html;
    description = "A hierarchical command-line task manager";
    license = licenses.gpl2;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
