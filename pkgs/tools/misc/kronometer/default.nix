{
  kdeDerivation, kdeWrapper, fetchurl, lib,
  extra-cmake-modules, kdoctools,
  kconfig, kinit
}:

let
  pname = "kronometer";
  version = "2.1.3";
  unwrapped = kdeDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
      sha256 = "1z06gvaacm3d3a9smlmgg2vf0jdab5kqxx24r6v7iprqzgdpsn4i";
    };

    meta = with lib; {
      license = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
    };
    nativeBuildInputs = [ extra-cmake-modules kdoctools ];
    propagatedBuildInputs = [ kconfig kinit ];
  };
in
kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kronometer" ];
}
