{
  kdeDerivation, kdeWrapper, fetchurl, lib,
  ecm, kdoctools,
  kconfig, kinit
}:

let
  pname = "kronometer";
  version = "2.1.0";
  unwrapped = kdeDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "1nh7y4c13rscy55f5n8s2v8jij27b55rwkxh9g8r0p7mdwmw8vri";
    };

    meta = with lib; {
      license = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
    };
    nativeBuildInputs = [ ecm kdoctools ];
    propagatedBuildInputs = [ kconfig kinit ];
  };
in
kdeWrapper unwrapped {
  targets = [ "bin/kronometer" ];
}
