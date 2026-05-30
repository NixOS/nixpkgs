{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-basic-ng";
  version = "1.0.0.beta2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = "sphinx-basic-ng";
    rev = version;
    hash = "sha256-MHBGIKOKhGklrx3O075LRud8NhY2hzlTWh+jalrFpko=";
  };

  propagatedBuildInputs = [ sphinx ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "sphinx_basic_ng" ];

  meta = {
    description = "Modernised skeleton for Sphinx themes";
    homepage = "https://sphinx-basic-ng.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
