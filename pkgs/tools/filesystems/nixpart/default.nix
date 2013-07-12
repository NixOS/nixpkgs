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
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/aszlig/nixpart/archive/v${version}.tar.gz";
    sha256 = "1kgiyqh7gndr0zs3qgi6r0dpy5p71d32c2k9kbd8pjf2xyyb6fk6";
  };

  propagatedBuildInputs = [ (blivet.override blivetOverrides) ];

  doCheck = false;

  meta = {
    description = "NixOS storage manager/partitioner";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
  };
}
