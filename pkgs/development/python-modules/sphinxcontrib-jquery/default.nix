{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-jquery";
  version = "3.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "jquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-argG+jMUqLiWo4lKWAmHmUxotHl+ddJuJZ/zcUl9u5Q=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  pythonImportsCheck = [
    "sphinxcontrib.jquery"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx
  ];

  meta = with lib; {
    description = "Extension to include jQuery on newer Sphinx releases";
    longDescription = ''
      A sphinx extension that ensures that jQuery is installed for use
      in Sphinx themes or extensions
    '';
    homepage = "https://github.com/sphinx-contrib/jquery";
    changelog = "https://github.com/sphinx-contrib/jquery/blob/v${version}/CHANGES.rst";
    license = licenses.bsd0;
    maintainers = with maintainers; [ kaction ];
  };
}
