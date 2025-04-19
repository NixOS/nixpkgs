{
  buildPythonPackage,
  fetchPypi,
  hatchling,
  lib,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
  # python packages
  matplotlib,
  networkx,
  numpy,
  pandas,
  requests,
  scipy,
  seaborn,
}:
buildPythonPackage rec {
  pname = "xgi";
  version = "0.10";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0QchgZ1Egcx5/8vSJPGLlN13A0KC+Q3dbAhWVB77Hdk=";
  };

  nativeBuildInputs = [
    hatchling
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    matplotlib
    networkx
    numpy
    pandas
    requests
    scipy
    seaborn
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  # set to false because of the issues with freetype versioning,
  # propogating from matplotlib. see matplotlib/default.nix.
  doCheck = false;

  pythonImportsCheck = [ "xgi" ];

  meta = with lib; {
    changelog = "https://github.com/xgi-org/xgi/blob/main/CHANGELOG.md#${
      builtins.replaceStrings ["."] [""] version
    }";
    description = "Software for higher-order networks";
    homepage = "https://xgi.readthedocs.io/";
    license = with licenses; [ bsd3 ];
  };
}
