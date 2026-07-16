{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic";
    inherit (finalAttrs) version;
    hash = "sha256-QCVEzJ4XlIlEEFTwnIB4BOEV6iRpB96HwDVftPWjEmg=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "xstatic" ];

  meta = {
    homepage = "https://github.com/xstatic-py/xstatic";
    description = "Base packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
