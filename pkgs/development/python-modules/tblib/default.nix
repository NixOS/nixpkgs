{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "tblib";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k2InkKCingTwNGRY+s4eFE3E0y9JNxTGw9/4Kkrbd+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = {
    description = "Traceback fiddling library. Allows you to pickle tracebacks";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ teh ];
  };
}
