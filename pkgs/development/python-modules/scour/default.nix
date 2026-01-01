{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "scour";
  version = "0.38.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf";
  };

  propagatedBuildInputs = [ six ];

  # No tests included in archive
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "SVG Optimizer / Cleaner";
    mainProgram = "scour";
    homepage = "https://github.com/scour-project/scour";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ worldofpeace ];
=======
  meta = with lib; {
    description = "SVG Optimizer / Cleaner";
    mainProgram = "scour";
    homepage = "https://github.com/scour-project/scour";
    license = licenses.asl20;
    maintainers = with maintainers; [ worldofpeace ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
