{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1.2";
    name="${baseName}-${version}";
    hash="13fgcvg71s1yp3r7jf1cs3kkpfw0pwykgmj7zryh24mw2269rx90";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.2.tar.gz";
    sha256="13fgcvg71s1yp3r7jf1cs3kkpfw0pwykgmj7zryh24mw2269rx90";
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
