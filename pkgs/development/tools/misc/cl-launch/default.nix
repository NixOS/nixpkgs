{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.0.2.2";
    name="${baseName}-${version}";
    hash="068bq66az3qhwgaxi9mx7f80396jilmd3zf4d3qamsyd81aq323c";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.0.2.2.tar.gz.asc";
    sha256="068bq66az3qhwgaxi9mx7f80396jilmd3zf4d3qamsyd81aq323c";
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
