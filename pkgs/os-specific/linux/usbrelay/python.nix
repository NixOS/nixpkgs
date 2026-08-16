{
  buildPythonPackage,
  setuptools,
  usbrelay,
}:

buildPythonPackage {
  pname = "usbrelay_py";
  pyproject = true;
  inherit (usbrelay) version src;

  build-system = [ setuptools ];

  preConfigure = ''
    cd usbrelay_py
  '';

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  inherit (usbrelay) meta;
}
