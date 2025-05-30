{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
}:
let
  pname = "stemming";
  version = "1.0.1";
in
buildPythonPackage {
  inherit version pname;
  format = "setuptools";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "nmstoker";
    repo = "stemming";
    rev = "477d0e354e79843f5ec241ba3603bcb5b843c3c4";
    hash = "sha256-wnmBCbxnCZ9mN1J7sLcN7OynMcvqgAnhEgpAwW2/xz4=";
  };

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "stemming" ];

  meta = with lib; {
    description = "Python implementations of various stemming algorithms";
    homepage = "https://github.com/nmstoker/stemming";
    license = licenses.unlicense;
    maintainers = with maintainers; [ happysalada ];
  };
}
