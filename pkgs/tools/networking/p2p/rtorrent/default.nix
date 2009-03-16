args: with args;
stdenv.mkDerivation ( rec {
  pname = "rtorrent";
  version = "0.7.9";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "f06f72b1fec94177147b1db0aab15be4f62d1b0354811a67ae74e0cd1e50a119";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl ];
  
  meta = {
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";
  };
})
