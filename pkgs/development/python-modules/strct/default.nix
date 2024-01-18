{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, pytestCheckHook
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "strct";
  version = "0.0.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaypal5";
    repo = "strct";
    rev = "v${version}";
    hash = "sha256-ctafvdfSOdp7tlCUYg7d5XTXR1qBcWvOVtGtNUnhYIw=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace  \
        "--cov" \
        "#--cov"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sortedcontainers
  ];

  pythonImportsCheck = [
    "strct"
    "strct.dicts"
    "strct.hash"
    "strct.lists"
    "strct.sets"
    "strct.sortedlists"
  ];

  meta = with lib; {
    description = "A small pure-python package for data structure related utility functions";
    homepage = "https://github.com/shaypal5/strct";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
