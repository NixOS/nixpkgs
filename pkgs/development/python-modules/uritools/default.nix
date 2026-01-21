{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "uritools";
  version = "6.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L56cuVTnh3Iysshj9ySkSgbrmNnH691pkUh26Uh7lPg=";
  };

  pythonImportsCheck = [ "uritools" ];

  meta = {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    homepage = "https://github.com/tkem/uritools/";
    changelog = "https://github.com/tkem/uritools/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
}
