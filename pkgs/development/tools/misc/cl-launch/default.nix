{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.0.4";
    name="${baseName}-${version}";
    hash="152m834myhcgi4iacfqn81fznlbqxn7pvdlxvk2lbba09h0slm56";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.0.4.tar.gz";
    sha256="152m834myhcgi4iacfqn81fznlbqxn7pvdlxvk2lbba09h0slm56";
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
