{ buildPythonPackage, usbrelay }:

buildPythonPackage rec {
  pname = "usbrelay_py";
  inherit (usbrelay) version src;

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  inherit (usbrelay) meta;
}
