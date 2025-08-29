{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  numpy,
  jsonschema,
  svgwrite,
}:

buildPythonPackage rec {
  pname = "tskit";
  version = "0.6.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vawbt+OuPR9WLsGRtdhAFW4ILdKtxq98QbFwxPsb55I=";
  };

  postPatch = ''
    # build-time constriant, used to ensure forward and backward compat
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0" "numpy"
  '';

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    numpy
    svgwrite
  ];

  # Pypi does not include test folder and too complex to compile from GitHub source
  # will ask upstream to include tests in pypi
  doCheck = false;

  pythonImportsCheck = [ "tskit" ];

  meta = {
    description = "Tree sequence toolkit";
    mainProgram = "tskit";
    homepage = "https://github.com/tskit-dev/tskit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
