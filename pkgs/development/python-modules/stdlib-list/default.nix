{ lib
, buildPythonPackage
, fetchPypi

# build-system
, flit-core
}:

buildPythonPackage rec {
  pname = "stdlib-list";
  version = "0.9.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "stdlib_list";
    inherit version;
    hash = "sha256-mOtmE1l2yWtO4/TA7wVS67Wpl3zjAoQz23n0c4sCryY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  pythonImportsCheck = [
    "stdlib_list"
  ];

  # tests see mismatches to our standard library
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/pypi/stdlib-list/releases/tag/v${version}";
    description = "A list of Python Standard Libraries";
    homepage = "https://github.com/jackmaney/python-stdlib-list";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
