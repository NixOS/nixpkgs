{
  lib,
  fetchPypi,
  buildPythonPackage,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "sslib";
  version = "0.2.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b5zrjkvx4klmv57pzhcmvbkdlyn745mn02k7hp811hvjrhbz417";
  };

  # No tests available
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/jqueiroz/python-sslib";
    description = "Python3 library for sharing secrets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jqueiroz ];
=======
  meta = with lib; {
    homepage = "https://github.com/jqueiroz/python-sslib";
    description = "Python3 library for sharing secrets";
    license = licenses.mit;
    maintainers = with maintainers; [ jqueiroz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
