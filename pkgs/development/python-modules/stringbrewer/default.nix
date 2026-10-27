{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  rstr,
  sre-yield,
}:

buildPythonPackage (finalAttrs: {
  pname = "stringbrewer";
  version = "0.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wtETgi+Tk1ALJzzIM6Ic5zkDbALGL0cELg8X75uepkk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rstr
    sre-yield
  ];

  # Package has no tests
  doCheck = false;
  pythonImportsCheck = [ "stringbrewer" ];

  meta = {
    description = "Python library to generate random strings matching a pattern";
    homepage = "https://github.com/simoncozens/stringbrewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
})
