{stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.13";
    name="${baseName}-${version}";
    hash="059sag372n09y1ddb1i0sx013kzkbr8a9pjqk03kyijn8h1z5hl2";
    url="mirror://sourceforge/project/conspy/conspy-1.13-1/conspy-1.13.tar.gz";
    sha256="059sag372n09y1ddb1i0sx013kzkbr8a9pjqk03kyijn8h1z5hl2";
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
