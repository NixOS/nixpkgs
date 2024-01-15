{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, flit-core

# dependencies
, appdirs
, cryptography
, id
, importlib-resources
, pydantic
, pyjwt
, pyopenssl
, requests
, rich
, securesystemslib
, sigstore-protobuf-specs
, sigstore-rekor-types
, tuf

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    rev = "v${version}";
    hash = "sha256-WH6Pme8ZbfW5xqBT056eVJ3HZP1D/lAULtyN6k0uMaA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    appdirs
    cryptography
    id
    importlib-resources
    pydantic
    pyjwt
    pyopenssl
    requests
    rich
    securesystemslib
    sigstore-protobuf-specs
    sigstore-rekor-types
    tuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigstore"
  ];

  meta = with lib; {
    description = "A codesigning tool for Python packages";
    homepage = "https://github.com/sigstore/sigstore-python";
    changelog = "https://github.com/sigstore/sigstore-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
