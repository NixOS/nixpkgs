{ stdenv, fetchurl, buildPythonPackage, blivet
# Propagated to blivet
, useNixUdev ? null, udevSoMajor ? null
}:

let
  blivetOverrides = stdenv.lib.filterAttrs (k: v: v != null) {
    inherit useNixUdev udevSoMajor;
  };
in buildPythonPackage rec {
  name = "nixpart-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "0avwd8p47xy9cydlbjxk8pj8q75zyl68gw2w6fnkk78dcb1a3swp";
  };

  propagatedBuildInputs = [ (blivet.override blivetOverrides) ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    platforms = stdenv.lib.platforms.linux;
  };
}
