{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "textdistance";
  version = "4.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1tq8ULTqgyzc8OHmAhvQx/zZreFViI15u2o8Mfzi3G8=";
  };

  build-system = [ setuptools ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "textdistance" ];

  meta = {
    description = "Python library for comparing distance between two or more sequences";
    homepage = "https://github.com/life4/textdistance";
    changelog = "https://github.com/life4/textdistance/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
