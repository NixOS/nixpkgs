{
  buildPythonPackage,
  setuptools,
  usbrelay,
}:

buildPythonPackage {
  pname = "usbrelay_py";
  version = "1.1";
  pyproject = true;
  inherit (usbrelay) src;

  build-system = [ setuptools ];

  preConfigure = ''
    cd usbrelay_py
  '';

  buildInputs = [ usbrelay ];

  pythonImportsCheck = [ "usbrelay_py" ];

  passthru.updateScript = null;

  inherit (usbrelay) meta;
}
