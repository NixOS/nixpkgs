{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xstatic";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "XStatic";
    inherit version;
    hash = "sha256-QCVEzJ4XlIlEEFTwnIB4BOEV6iRpB96HwDVftPWjEmg=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://bitbucket.org/thomaswaldmann/xstatic";
    description = "Base packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
