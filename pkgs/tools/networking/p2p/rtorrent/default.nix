args: with args;
stdenv.mkDerivation ( rec {
  pname = "rtorrent";
  version = "0.8.5";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "0ra6k0avh85fx1rr6wldxy6ns5p0np4c5dc7wsjqycg9f8brkihf";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl ];
  
  meta = {
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";
  };
})
