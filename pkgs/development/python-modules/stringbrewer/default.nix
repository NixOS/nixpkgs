{
  lib,
  buildPythonPackage,
  fetchPypi,
  rstr,
  sre-yield,
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

  # Package has no tests
  doCheck = false;
  pythonImportsCheck = [ "stringbrewer" ];

<<<<<<< HEAD
  meta = {
    description = "Python library to generate random strings matching a pattern";
    homepage = "https://github.com/simoncozens/stringbrewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
=======
  meta = with lib; {
    description = "Python library to generate random strings matching a pattern";
    homepage = "https://github.com/simoncozens/stringbrewer";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
