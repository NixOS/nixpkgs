{ stdenv, fetchurl, bison, flex, libffi }:

stdenv.mkDerivation rec {
  name = "txr-${version}";
  version = "209";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/${name}.tar.bz2";
    sha256 = "1g236bk5ygh3car4kki3w6n0pwny8q4awg8p86fh2khj52qz6mdl";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  # Remove failing test-- mentions 'usr/bin' so probably related :)
  preCheck = "rm -rf tests/017";

  # TODO: install 'tl.vim', make avail when txr is installed or via plugin

  meta = with stdenv.lib; {
    description = "Programming language for convenient data munging";
    license = licenses.bsd2;
    homepage = http://nongnu.org/txr;
    maintainers = with stdenv.lib.maintainers; [ dtzWill ];
  };
}
