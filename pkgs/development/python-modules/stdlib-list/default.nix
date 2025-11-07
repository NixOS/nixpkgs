{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "stdlib-list";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "stdlib_list";
    inherit version;
    hash = "sha256-UXgk8n7onlkdiufB3Z/zT2curlDuiG6jG7iBbXdTVnU=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "stdlib_list" ];

  # tests see mismatches to our standard library
  doCheck = false;

  meta = with lib; {
    description = "List of Python Standard Libraries";
    homepage = "https://github.com/jackmaney/python-stdlib-list";
    changelog = "https://github.com/pypi/stdlib-list/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
