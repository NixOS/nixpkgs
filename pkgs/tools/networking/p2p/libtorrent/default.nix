args: with args;
stdenv.mkDerivation ( rec {
  pname = "libtorrent";
  version = "0.11.9";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "71f09218a7784b21ab53cdfcd8fa122da60352e5ca117fda7cd8d2763f908a08";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];
  
  meta = {
    description = "
      LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
    ";
  };
})
