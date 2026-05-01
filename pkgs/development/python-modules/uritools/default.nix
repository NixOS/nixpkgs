{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vpfkUlKOekLvCk32g2Td13gz6YLFusXNz+4VyB9l6Ws=";
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
