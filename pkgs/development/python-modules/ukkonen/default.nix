{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cffi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ukkonen";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "ukkonen";
    rev = "v${version}";
    sha256 = "jG6VP/P5sadrdrmneH36/ExSld9blyMAAG963QS9+p0=";
  };

  nativeBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ukkonen" ];

<<<<<<< HEAD
  meta = {
    description = "Python implementation of bounded Levenshtein distance (Ukkonen)";
    homepage = "https://github.com/asottile/ukkonen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python implementation of bounded Levenshtein distance (Ukkonen)";
    homepage = "https://github.com/asottile/ukkonen";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
