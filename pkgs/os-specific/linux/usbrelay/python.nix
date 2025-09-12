{ buildPythonPackage, usbrelay }:

buildPythonPackage {
  format = "setuptools";
  pname = "usbrelay_py";
  inherit (usbrelay) version src;

  preConfigure = ''
    cd usbrelay_py
  '';

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  inherit (usbrelay) meta;
}
