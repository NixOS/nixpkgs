{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, nose
, isPy27
, numpy
, scipy
, sparse
, pytorch
}:

buildPythonPackage rec {
  pname = "tensorly";
  version = "0.4.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1ml91yaxwx4msisxbm92yf22qfrscvk58f3z2r1jhi96pw2k4i7x";
  };

  propagatedBuildInputs = [ numpy scipy sparse ];
  checkInputs = [ pytest nose pytorch ];
  # also has a cupy backend, but the tests are currently broken
  # (e.g. attempts to access cupy.qr instead of cupy.linalg.qr)
  # and this backend also adds a non-optional CUDA dependence,
  # as well as tensorflow and mxnet backends, but the tests don't
  # seem to exercise these backend by default

  checkPhase = ''
    runHook preCheck
    nosetests -e "test_cupy"
    runHook postCheck
  '';

  meta = with lib; {
    description = "Tensor learning in Python";
    homepage = https://tensorly.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.bcdarwin ];
  };
}
