{ lib, python, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "simplefix";
  version = "1.0.15";

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
    rev = "v${version}";
    hash = "sha256-GQHMotxNRuRv6zXhrD02T+aFgfYe3RnvUGADsBeSPbA=";
  };

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest all
  '';

  meta = with lib; {
    description = "Simple FIX Protocol implementation for Python";
    homepage = "https://github.com/da4089/simplefix";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
