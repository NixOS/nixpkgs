{ lib
, buildPythonPackage
, fetchFromGitHub
, octodns
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools
}:

buildPythonPackage rec {
  pname = "octodns-gandi";
  version = "0.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "octodns";
    repo = "octodns-gandi";
    rev = "refs/tags/v${version}";
    hash = "sha256-aZUVdCeIbyXBgy8HNf6bZSmjdRzIvQkCEzndKGyuTkw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    octodns
    requests
  ];

  pythonImportsCheck = [ "octodns_gandi" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Gandi v5 API provider for octoDNS";
    homepage = "https://github.com/octodns/octodns-gandi";
    changelog = "https://github.com/octodns/octodns-gandi/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
