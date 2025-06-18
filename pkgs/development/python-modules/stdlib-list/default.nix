{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,
}:

buildPythonPackage rec {
  pname = "stdlib-list";
  version = "0.11.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "stdlib_list";
    inherit version;
    hash = "sha256-levR1z2pMzu6A8zAl/W6wF46oD5oIqDAKQ+H4QR/GFc=";
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
