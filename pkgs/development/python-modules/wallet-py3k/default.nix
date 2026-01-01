{
  lib,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  openssl,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "wallet-py3k";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kyHSh8qHbzK6gFLGnL6dUJ/GLJHTNC86jjXa/APqIzI=";
  };

  patches = [
    (replaceVars ./openssl-path.patch {
      openssl = lib.getExe openssl;
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ six ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "wallet" ];

<<<<<<< HEAD
  meta = {
    description = "Passbook file generator";
    homepage = "https://pypi.org/project/wallet-py3k";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    description = "Passbook file generator";
    homepage = "https://pypi.org/project/wallet-py3k";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
