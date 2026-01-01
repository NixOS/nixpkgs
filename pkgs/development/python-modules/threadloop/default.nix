{
  buildPythonPackage,
  fetchPypi,
  lib,
  tornado,
}:

buildPythonPackage rec {
  pname = "threadloop";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b180aac31013de13c2ad5c834819771992d350267bddb854613ae77ef571944";
  };

  propagatedBuildInputs = [ tornado ];

  doCheck = false; # ImportError: cannot import name 'ThreadLoop' from 'threadloop'

  pythonImportsCheck = [ "threadloop" ];

<<<<<<< HEAD
  meta = {
    description = "Library to run tornado coroutines from synchronous Python";
    homepage = "https://github.com/GoodPete/threadloop";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Library to run tornado coroutines from synchronous Python";
    homepage = "https://github.com/GoodPete/threadloop";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
