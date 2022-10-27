{ buildPythonPackage, usbrelay }:

buildPythonPackage rec {
  pname = "usbrelay_py";
  inherit (usbrelay) version src;

  preConfigure = ''
    cd usbrelay_py
  '';

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  inherit (usbrelay) meta;
}
