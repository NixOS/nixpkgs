{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="3.22.1";
    name="${baseName}-${version}";
    hash="08lb8nm4dvkbgraqclw5xd7j6xskw9hgjpg9ql087gib5a90k09i";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-3.22.1.tar.gz";
    sha256="08lb8nm4dvkbgraqclw5xd7j6xskw9hgjpg9ql087gib5a90k09i";
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
