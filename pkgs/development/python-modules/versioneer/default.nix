{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, tomli
}:

buildPythonPackage rec {
  pname = "versioneer";
  version = "0.29";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-versioneer";
    repo = "python-versioneer";
    rev = "refs/tags/${version}";
    hash = "sha256-3b7Wfhd24Vym5XCeN/M1832Q1VzvlWi3quTRaZrID2s=";
  };

  nativeBuildInputs = [
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    toml = lib.optionals (pythonOlder "3.11") [
      tomli
    ];
  };

  # Couldn't get tests to work because, for instance, they used virtualenv and pip
  doCheck = false;

  pythonImportsCheck = [
    "versioneer"
  ];

  meta = with lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = "https://github.com/python-versioneer/python-versioneer";
    changelog = "https://github.com/python-versioneer/python-versioneer/blob/${version}/NEWS.md";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };
}
