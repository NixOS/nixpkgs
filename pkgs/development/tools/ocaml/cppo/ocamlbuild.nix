{ lib, buildDunePackage, cppo, ocamlbuild }:

if !lib.versionAtLeast (lib.getVersion cppo) "1.6"
then cppo
else

buildDunePackage rec {
  pname = "cppo_ocamlbuild";

  inherit (cppo) version useDune2 src;

  propagatedBuildInputs = [ ocamlbuild ];

  meta = cppo.meta // {
    description = "Plugin to use cppo with ocamlbuild";
  };
}
