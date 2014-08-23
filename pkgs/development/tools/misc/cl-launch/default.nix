{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.0.5";
    name="${baseName}-${version}";
    hash="00i11pkwsb9r9cjzxjmj0dsp369i0gpz04f447xss9a9v192dhlj";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.0.5.tar.gz";
    sha256="00i11pkwsb9r9cjzxjmj0dsp369i0gpz04f447xss9a9v192dhlj";
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
