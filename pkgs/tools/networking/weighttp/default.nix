{ stdenv, fetchurl, python, libev}:
stdenv.mkDerivation {
  name = "weighttp-0.3";
  src = fetchurl {
    url = http://cgit.lighttpd.net/weighttp.git/snapshot/weighttp-0.3.tar.gz;
    sha256 = "0gl83vnip3nj7fdgbwqkmrx7kxp51sri9jfiwd04q9iz8f9bsmz5";
  };

  buildInputs = [ python libev ];
  installPhase = ''
    python waf configure --prefix=$out
    python waf build
    python waf install
  '';
}
