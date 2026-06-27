{
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "support-setuptools-82.patch";
      url = "https://github.com/shaypal5/strct/commit/5005a939b590cd992d985128a2c1dba230a7fe41.patch";
      includes = [ "setup.py" ];
      hash = "sha256-0vRRst79G6JZZ+IzBR7rr85nOo0qY0ikVBz4Lvauwbc=";
    })
  ];

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

  meta = {
    description = "Small pure-python package for data structure related utility functions";
    homepage = "https://github.com/shaypal5/strct";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
