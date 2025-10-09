{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "stdlibs";
  version = "2025.5.10";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "stdlibs";
    tag = "v${version}";
    hash = "sha256-pvQZ+sRmad5m274wbIulHh5Tifim35uH7mz69jopVRw=";
  };

  build-system = [ flit-core ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "stdlibs" ];

  meta = with lib; {
    description = "Overview of the Python stdlib";
    homepage = "https://github.com/omnilib/stdlibs";
    changelog = "https://github.com/omnilib/stdlibs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
