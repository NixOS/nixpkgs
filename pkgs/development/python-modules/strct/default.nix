{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  sortedcontainers,
}:

buildPythonPackage rec {
  pname = "strct";
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaypal5";
    repo = "strct";
    tag = "v${version}";
    hash = "sha256-4IykGzy1PTrRAbx/sdtzL4My4cDSlplL9rOFBcLbaB8=";
  };

  # don't append .dev0 to version
  env.RELEASING_PROCESS = "1";

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
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
    description = "Small pure-python package for data structure related utility functions";
    homepage = "https://github.com/shaypal5/strct";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
