{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1";
    name="${baseName}-${version}";
    hash="0fmxa8013sgxmbfmh1wqffywg72zynzlw5yyrdvy9qpx1my36pwb";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.tar.gz";
    sha256="0fmxa8013sgxmbfmh1wqffywg72zynzlw5yyrdvy9qpx1my36pwb";
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
