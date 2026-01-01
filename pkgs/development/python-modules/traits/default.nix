{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "traits";
<<<<<<< HEAD
  version = "7.1.0";
=======
  version = "7.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-r0d1dH4R4F/+E9O6Rj2S9n8fPRqeT0a6M6ROoisMlkQ=";
=======
    hash = "sha256-pWNRWAnLORGXXeWlQgmFXwtv23ymkSpegd4mUp9wQow=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "traits" ];

  meta = {
    description = "Explicitly typed attributes for Python";
    homepage = "https://pypi.python.org/pypi/traits";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
