{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-basic-ng";
  version = "1.0.0.beta1";
  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-basic-ng";
    rev = version;
    hash = "sha256-Zh9KvKs4js+AVSfIk0pAj6Kzq/O2m/MGTF+HCwYJTXk=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "sphinx_basic_ng" ];

  meta = with lib; {
    description = "A modernised skeleton for Sphinx themes";
    homepage = "https://sphinx-basic-ng.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
