{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, tomli
}:

buildPythonPackage rec {
  pname = "versioneer";
  version = "0.27";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-versioneer";
    repo = "python-versioneer";
    rev = "refs/tags/${version}";
    hash = "sha256-yCO9dqqEUdvLDLAfHkYUA+dHwn2OLrFlubWeGbvlAbA=";
  };

  nativeBuildInputs = [
    setuptools
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  # Couldn't get tests to work because, for instance, they used virtualenv and pip
  doCheck = false;

  pythonImportsCheck = [
    "versioneer"
  ];

  meta = with lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = "https://github.com/warner/python-versioneer";
    changelog = "https://github.com/python-versioneer/python-versioneer/blob/${version}/NEWS.md";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };
}
