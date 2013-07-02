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
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "1z94h76jn9igksgr84wwbi03fjamwb15hg432x189kgsld1ark4n";
  };

  propagatedBuildInputs = [ (blivet.override blivetOverrides) ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}
