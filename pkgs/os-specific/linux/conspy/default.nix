{stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.14";
    name="${baseName}-${version}";
    hash="069k26xpzsvrn3197ix5yd294zvz03zi2xqj4fip6rlsw74habsf";
    url="mirror://sourceforge/project/conspy/conspy-1.14-1/conspy-1.14.tar.gz";
    sha256="069k26xpzsvrn3197ix5yd294zvz03zi2xqj4fip6rlsw74habsf";
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
