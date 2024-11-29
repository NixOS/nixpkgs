{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,
}:

buildPythonPackage rec {
  pname = "stdlib-list";
  version = "0.11.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "stdlib_list";
    inherit version;
    hash = "sha256-t0p7ZDp3oSY36Qfz9i8KufZzALzkAU9rLTyLTI/WPGY=";
  };

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "stdlib_list" ];

  # tests see mismatches to our standard library
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/pypi/stdlib-list/releases/tag/v${version}";
    description = "List of Python Standard Libraries";
    homepage = "https://github.com/jackmaney/python-stdlib-list";
    license = licenses.mit;
    maintainers = [ ];
  };
}
