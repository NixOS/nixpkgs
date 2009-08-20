args: with args;
stdenv.mkDerivation ( rec {
  pname = "libtorrent";
  version = "0.12.5";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "1hcxc9aalkswb1v6ww8yf0a8dfc449g6cghndhbj0m9rzl6gfqz9";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];
  
  meta = {
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";
  };
})
