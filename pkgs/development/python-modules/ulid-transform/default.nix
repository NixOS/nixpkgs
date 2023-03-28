{ lib
, cython
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "ulid-transform";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tgCNjvI9e7GpZKG8Q6tykU+WKBPGm0FTsw3gwUU3+so=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ulid_transform --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "ulid_transform"
  ];

  meta = with lib; {
    description = "Library to create and transform ULIDs";
    homepage = "https://github.com/bdraco/ulid-transform";
    changelog = "https://github.com/bdraco/ulid-transform/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
