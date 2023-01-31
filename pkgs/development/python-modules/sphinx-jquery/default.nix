{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonImportsCheckHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-jquery";
  version = "3.0.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "jquery";
    rev = "v${version}";
    hash = "sha256-argG+jMUqLiWo4lKWAmHmUxotHl+ddJuJZ/zcUl9u5Q=";
  };

  nativeBuildInputs = [
    pythonImportsCheckHook
    flit-core
  ];

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinxcontrib.jquery" ];

  meta = with lib; {
    description = "A sphinx extension that ensures that jQuery is installed for use in Sphinx themes or extensions";
    homepage = "https://github.com/sphinx-contrib/jquery";
    license = licenses.bsd0;
    maintainers = with maintainers; [ kaction ];
  };
}
