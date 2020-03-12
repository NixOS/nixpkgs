{ stdenv, fetchurl, readline, ncurses }:

stdenv.mkDerivation rec {
  pname = "devtodo";
  version = "0.1.20";

  src = fetchurl {
    url = "https://swapoff.org/files/devtodo/${pname}-${version}.tar.gz";
    sha256 = "029y173njydzlznxmdizrrz4wcky47vqhl87fsb7xjcz9726m71p";
  };

  buildInputs = [ readline ncurses ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://swapoff.org/devtodo1.html;
    description = "A hierarchical command-line task manager";
    license = licenses.gpl2;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.linux;
  };
}
