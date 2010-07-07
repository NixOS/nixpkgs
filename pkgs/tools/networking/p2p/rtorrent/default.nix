args: with args;
stdenv.mkDerivation ( rec {
  pname = "rtorrent";
  version = "0.8.6";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "1nrj1cgjhscf40zhp70m4p6gq96rqg815dn43yyjl5i42n7cd5lc";
  };

  buildInputs = [ libtorrent ncurses pkgconfig libsigcxx curl zlib openssl ];
  
  meta = {
    description = "An ncurses client for libtorrent, ideal for use with screen or dtach";
  };
})
