{lib, stdenv, fetchurl, libdmtx, pkg-config, imagemagick}:
let
  s = # Generated upstream information
  rec {
    baseName="dmtx-utils";
    version="0.7.4";
    name="${baseName}-${version}";
    hash="1di8ymlziy9856abd6rb72z0zqzmrff4r3vql0q9r5sk5ax4s417";
    url="mirror://sourceforge/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.tar.gz";
    sha256="1di8ymlziy9856abd6rb72z0zqzmrff4r3vql0q9r5sk5ax4s417";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libdmtx imagemagick
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = "Data matrix command-line utilities";
    license = lib.licenses.lgpl2 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
  };
}
