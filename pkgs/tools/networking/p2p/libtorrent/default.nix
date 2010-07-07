args: with args;
stdenv.mkDerivation ( rec {
  pname = "libtorrent";
  version = "0.12.6";

  name = "${pname}-${version}";
  
  src = fetchurl {
    url = "http://libtorrent.rakshasa.no/downloads/${name}.tar.gz";
    sha256 = "0abisz3jgfv4zmyzbsknzvz9hwakxxpdgfl33qk0aslnchqz60kv";
  };

  buildInputs = [ pkgconfig openssl libsigcxx ];
  
  meta = {
    description = "A BitTorrent library written in C++ for *nix, with a focus on high performance and good code";
  };
})
