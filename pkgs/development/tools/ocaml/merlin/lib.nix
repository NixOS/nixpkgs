{
  lib,
  buildDunePackage,
  merlin,
  csexp,
}:

buildDunePackage {
  pname = "merlin-lib";
  inherit (merlin) version src;

  minimalOCamlVersion = "4.14";

  propagatedBuildInputs = [ csexp ];

  meta = merlin.meta // {
    description = "Merlin’s libraries";
  };
}
