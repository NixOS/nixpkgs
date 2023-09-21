{ lib, buildDunePackage, cppo, ocamlbuild }:

if lib.versionOlder (lib.getVersion cppo) "1.6"
then cppo
else

buildDunePackage {
  pname = "cppo_ocamlbuild";

  inherit (cppo) version src;

  minimalOCamlVersion = "4.03";
  duneVersion = "3";

  propagatedBuildInputs = [ ocamlbuild ];

  meta = cppo.meta // {
    description = "Plugin to use cppo with ocamlbuild";
  };
}
