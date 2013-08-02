{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="3.21.1";
    name="${baseName}-${version}";
    hash="1241lyn2a3ry06ii9zlns0cj462bi7rih41vlbbmra1chj4c21ij";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-3.21.1.tar.gz";
    sha256="1241lyn2a3ry06ii9zlns0cj462bi7rih41vlbbmra1chj4c21ij";
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

  meta = {
    inherit (s) version;
    description = ''Common Lisp launcher script'';
    license = stdenv.lib.licenses.llgpl21 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
