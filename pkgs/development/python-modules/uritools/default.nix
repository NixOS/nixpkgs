{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-78XDpt4FQEhQaFqNPzTahHa1aqNRb7+O/1yHBMeigm8=";
  };

  pythonImportsCheck = [
    "uritools"
  ];

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
