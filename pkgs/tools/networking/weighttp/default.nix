{ stdenv, fetchurl, python, libev}:
stdenv.mkDerivation {
  name = "weighttp-0.3";
  src = fetchurl {
    url = http://cgit.lighttpd.net/weighttp.git/snapshot/weighttp-0.3.tar.gz;
    sha256 = "09mrpwjnipmxayqzzhs110lipq41nsyk5pwp2rc6wnlj3266g6pi";
  };

  buildInputs = [ python libev ];
  installPhase = ''
    python waf configure --prefix=$out
    python waf build
    python waf install
  '';
}
