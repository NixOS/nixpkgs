{ lib, buildPythonPackage, fetchFromGitHub, pytest, which, lrzsz }:

buildPythonPackage rec {
  pname = "xmodem";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "xmodem";
    rev = version;
    sha256 = "1xx7wd8bnswxa1fv3bfim2gcamii79k7qmwg7dbxbjvrhbcjjc0l";
  };

  nativeCheckInputs = [ pytest which lrzsz ];

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
