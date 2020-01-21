{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, which, lrzsz }:

buildPythonPackage rec {
  pname = "xmodem";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "tehmaze";
    repo = "xmodem";
    rev = version;
    sha256 = "0nz2gxwaq3ys1knpw6zlz3xrc3ziambcirg3fmp3nvzjdq8ma3h0";
  };

  checkInputs = [ pytest which lrzsz ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Pure python implementation of the XMODEM protocol";
    maintainers = with maintainers; [ emantor ];
    homepage = https://github.com/tehmaze/xmodem;
    license = licenses.mit;
  };
}
