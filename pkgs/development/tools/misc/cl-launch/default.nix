{lib, stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="cl-launch";
    version="4.1.4.1";
    name="${baseName}-${version}";
    hash="09450yknzb0m3375lg4k8gdypmk3xwl8m1krv1kvhylmrm3995mz";
    url="http://common-lisp.net/project/xcvb/cl-launch/cl-launch-4.1.4.1.tar.gz";
    sha256="09450yknzb0m3375lg4k8gdypmk3xwl8m1krv1kvhylmrm3995mz";
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
    description = "Common Lisp launcher script";
    license = lib.licenses.llgpl21 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
