{
  lib,
  buildPythonPackage,
  fetchPypi,
  rstr,
  sre-yield,
  pythonImportsCheckHook,
}:

buildPythonPackage rec {
  pname = "stringbrewer";
  version = "0.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wtETgi+Tk1ALJzzIM6Ic5zkDbALGL0cELg8X75uepkk=";
  };

  propagatedBuildInputs = [
    rstr
    sre-yield
  ];
  nativeBuildInputs = [ pythonImportsCheckHook ];

  # Package has no tests
  doCheck = false;
  pythonImportsCheck = [ "stringbrewer" ];

  meta = with lib; {
    description = "Python library to generate random strings matching a pattern";
    homepage = "https://github.com/simoncozens/stringbrewer";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
