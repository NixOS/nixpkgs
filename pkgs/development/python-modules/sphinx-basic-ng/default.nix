{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-basic-ng";
  version = "1.0.0.beta2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-basic-ng";
    rev = version;
    hash = "sha256-MHBGIKOKhGklrx3O075LRud8NhY2hzlTWh+jalrFpko=";
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
