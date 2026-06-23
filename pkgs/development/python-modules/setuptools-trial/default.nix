{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  twisted,
}:

buildPythonPackage rec {
  pname = "setuptools-trial";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_trial";
    inherit version;
    hash = "sha256-FCIPj3YcSLoeJSbwhxlQd89U+tcJizgs4iBCLw/1mxI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ twisted ];

  # Couldn't get tests working
  doCheck = false;

  pythonImportsCheck = [ "setuptools_trial" ];

  meta = {
    description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit";
    homepage = "https://github.com/rutsky/setuptools-trial";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ryansydnor ];
  };
}
