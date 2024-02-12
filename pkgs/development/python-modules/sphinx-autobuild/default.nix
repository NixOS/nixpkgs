{ lib
, buildPythonPackage
, fetchFromGitHub
, colorama
, flit-core
, pytestCheckHook
, sphinx
, livereload
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2024.02.04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinx-autobuild";
    rev = version;
    hash = "sha256-9/ZeQR/EqvOMDiDt3MBtEm0VwFeQnmNGc8ie1Pq1yR8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    colorama
    sphinx
    livereload
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sphinx_autobuild" ];

  meta = with lib; {
    description = "Rebuild Sphinx documentation on changes, with live-reload in the browser";
    homepage = "https://github.com/executablebooks/sphinx-autobuild";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ holgerpeters ];
  };
}
