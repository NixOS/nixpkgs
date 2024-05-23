{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "strct";
  version = "0.0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaypal5";
    repo = "strct";
    rev = "v${version}";
    hash = "sha256-uPM2U+emZUCGqEhIeTBmaOu8eSfK4arqvv9bItBWpUs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail  \
        '"--cov' \
        '#"--cov'
  '';

  # don't append .dev0 to version
  env.RELEASING_PROCESS = "1";

  nativeBuildInputs = [ setuptools ];

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
