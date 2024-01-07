{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stdlibs";
  version = "2023.12.15";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "stdlibs";
    rev = "refs/tags/v${version}";
    hash = "sha256-1Av10FNJkCC2XGNx1LDqd0GwiNPIDPXPFatW8+2XoaI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "stdlibs"
  ];

  meta = with lib; {
    description = "Overview of the Python stdlib";
    homepage = "https://github.com/omnilib/stdlibs";
    changelog = "https://github.com/omnilib/stdlibs/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
