{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "stringcase";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "023hv3gknblhf9lx5kmkcchzmbhkdhmsnknkv7lfy20rcs06k828";
  };

  # PyPi package does not include tests.
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/okunishinishi/python-stringcase";
    description = "Convert string cases between camel case, pascal case, snake case etc…";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alunduil ];
=======
  meta = with lib; {
    homepage = "https://github.com/okunishinishi/python-stringcase";
    description = "Convert string cases between camel case, pascal case, snake case etc…";
    license = licenses.mit;
    maintainers = with maintainers; [ alunduil ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
