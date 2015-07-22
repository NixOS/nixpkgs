{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1.3.3";
    name="${baseName}-${version}";
    hash="1al7jrj4fy9w4lpgizgb1ppk4rhhlcrfkz1yxpjv3w0wij1h67zl";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.3.3.tar.gz";
    sha256="1al7jrj4fy9w4lpgizgb1ppk4rhhlcrfkz1yxpjv3w0wij1h67zl";
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
