{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  which,
  lrzsz,
}:

buildPythonPackage rec {
  pname = "xmodem";
  version = "0.4.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "xmodem";
    tag = version;
    sha256 = "sha256-kwPA/lYiv6IJSKGRuH13tBofZwp19vebwQniHK7A/i8=";
  };

  nativeCheckInputs = [
    pytest
    which
    lrzsz
  ];

  checkPhase = ''
    pytest
  '';

<<<<<<< HEAD
  meta = {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with lib.maintainers; [ emantor ];
    homepage = "https://github.com/tehmaze/xmodem";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with maintainers; [ emantor ];
    homepage = "https://github.com/tehmaze/xmodem";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
