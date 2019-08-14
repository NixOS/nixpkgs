{ lib, python, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "simplefix";
  version = "1.0.12";

  src = fetchFromGitHub {
    repo = "simplefix";
    owner = "da4089";
    rev = "v${version}";
    sha256 = "0pnyqxpki1ija0kha7axi6irgiifcz4w77libagkv46b1z11cc4r";
  };

  checkPhase = ''
    cd test
    ${python.interpreter} -m unittest all
  '';

  meta = with lib; {
    description = "Simple FIX Protocol implementation for Python";
    homepage = https://github.com/da4089/simplefix;
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
