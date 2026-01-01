{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "syncer";
  version = "2.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miyakogi";
    repo = "syncer";
    rev = "v${version}";
    sha256 = "sha256-3EYWy6LuZ/3i+9d0QaclCqWMMw5O3WzhTY3LUL5iMso=";
  };

  # Tests require an not maintained package (xfail)
  doCheck = false;

  pythonImportsCheck = [ "syncer" ];

<<<<<<< HEAD
  meta = {
    description = "Python async to sync converter";
    homepage = "https://github.com/miyakogi/syncer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python async to sync converter";
    homepage = "https://github.com/miyakogi/syncer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
