{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1.4";
    name="${baseName}-${version}";
    hash="0j3lapjsqzdkc7ackqdk13li299lp706gdc9bh28kvs0diyamjiv";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.4.tar.gz";
    sha256="0j3lapjsqzdkc7ackqdk13li299lp706gdc9bh28kvs0diyamjiv";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  preConfigure = ''
    export makeFlags="$makeFlags PREFIX='$out'"
    mkdir -p "$out/bin"
  '';

  preBuild = ''
    sed -e 's/\t\t@/\t\t/g' -i Makefile
  '';

  meta = {
    inherit (s) version;
    description = ''Common Lisp launcher script'';
    license = stdenv.lib.licenses.llgpl21 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
