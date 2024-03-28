{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, certifi
, charset-normalizer
, dataclasses-json
, deepdiff
, idna
, jsonpath-python
, marshmallow
, mypy-extensions
, packaging
, pypdf
, python-dateutil
, requests
, six
, typing-inspect
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "unstructured-python-client";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Unstructured-IO";
    repo = "unstructured-python-client";
    rev = "v${version}";
    hash = "sha256-C3kpDD+EA1jJurZpGV0nVFqcwEOz4Daem8p2HKDR9gA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    certifi
    charset-normalizer
    dataclasses-json
    deepdiff
    idna
    jsonpath-python
    marshmallow
    mypy-extensions
    packaging
    pypdf
    python-dateutil
    requests
    six
    typing-inspect
    typing-extensions
    urllib3
  ];

  pythonImportsCheck = [ "unstructured_client" ];

  meta = with lib; {
    description = "A Python client for the Unstructured hosted API";
    homepage = "https://github.com/Unstructured-IO/unstructured-python-client";
    changelog = "https://github.com/Unstructured-IO/unstructured-python-client/blob/${src.rev}/RELEASES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
