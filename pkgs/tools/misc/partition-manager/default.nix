{ kdeDerivation, kdeWrapper, fetchurl, lib
, ecm, kdoctools
, kconfig, kinit, kpmcore
, eject, libatasmart }:

let
  pname = "partitionmanager";
  unwrapped = kdeDerivation rec {
    name = "${pname}-${version}";
    version = "3.0.1";

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "08sb9xa7dvvgha3k2xm1srl339przxpxd2y5bh1lnx6k1x7dk410";
    };

    meta = with lib; {
      description = "KDE Partition Manager";
      license = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
    };
    nativeBuildInputs = [ ecm kdoctools ];
    # refer to kpmcore for the use of eject
    buildInputs = [ eject libatasmart ];
    propagatedBuildInputs = [ kconfig kinit kpmcore ];
    enableParallelBuilding = true;
  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/partitionmanager" ];
}
