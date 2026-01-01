{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
<<<<<<< HEAD
  version = "6.32.1.20251105";
=======
  version = "6.30.2.20250703";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchPypi {
    pname = "types_protobuf";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-ZBACYR/4fdn+3DijminKy5kHrlzmFIm1PpnKIHS+92Q=";
=======
    hash = "sha256-YJqXR1S7tx+hePxkH1EFA5Xo4YSfSdBCCmKB7Y0d30Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

<<<<<<< HEAD
  meta = {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
=======
  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
