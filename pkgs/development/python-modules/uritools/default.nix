{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "420d94c1ff4bf90c678fca9c17b8314243bbcaa992c400a95e327f7f622e1edf";
  };

  pythonImportsCheck = [
    "uritools"
  ];

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
