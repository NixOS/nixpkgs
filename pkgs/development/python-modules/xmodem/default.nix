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
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with maintainers; [ emantor ];
    homepage = "https://github.com/tehmaze/xmodem";
    license = licenses.mit;
  };
}
