{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1.1";
    name="${baseName}-${version}";
    hash="1nimbv1ms7fcikx8y6dxrzdm63psf4882z5kjr6qdyarqz6gaq20";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.1.tar.gz";
    sha256="1nimbv1ms7fcikx8y6dxrzdm63psf4882z5kjr6qdyarqz6gaq20";
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
