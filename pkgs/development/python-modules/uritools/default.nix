{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "6.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TWccO4yiMKXUfvpfimk/PQFTHzj09SMXApm+c0zJhRs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "uritools" ];

  meta = {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
}
