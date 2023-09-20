{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "stdlibs";
  version = "2022.10.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = "stdlibs";
    rev = "refs/tags/v${version}";
    hash = "sha256-HkGZw58gQGd8mHnCP4aF6JWXxlpIIfe7B//HJiHVwA4=";
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
