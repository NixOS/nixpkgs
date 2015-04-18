{stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.10";
    name="${baseName}-${version}";
    hash="1vnph4xa1qp4sr52jc9zldmbdpkr6z5j7hk2vgyhfn7m1vc5g0qw";
    url="mirror://sourceforge/project/conspy/conspy-1.10-1/conspy-1.10.tar.gz";
    sha256="1vnph4xa1qp4sr52jc9zldmbdpkr6z5j7hk2vgyhfn7m1vc5g0qw";
  };
  buildInputs = [
    autoconf automake ncurses
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
    curlOpts = " -A application/octet-stream ";
  };
  preConfigure = ''
    touch NEWS
    echo "EPL 1.0" > COPYING
    aclocal
    automake --add-missing
    autoconf
  '';
  meta = {
    inherit (s) version;
    description = "Linux text console viewer";
    license = stdenv.lib.licenses.epl10 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
