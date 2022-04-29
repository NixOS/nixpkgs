{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, isPy27
, numpy
, scipy
, sparse
}:

buildPythonPackage rec {
  pname = "tensorly";
  version = "0.7.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "VcX3pCczZQUYZaD7xrrkOcj0QPJt28cYTwpZm5D/X3c=";
  };

  # nose is not actually required for anything
  # (including testing with the minimal dependencies)
  postPatch = ''
    substituteInPlace setup.py --replace ", 'nose'" ""
  '';

  propagatedBuildInputs = [ numpy scipy sparse ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tensorly" ];

  pythonImportsCheck = [ "tensorly" ];

  meta = with lib; {
    description = "Tensor learning in Python";
    homepage = "https://tensorly.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
