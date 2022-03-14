{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-W4K1xumR8HBadvlh9DJip/seVbCTwW3Kg/FjhKfzm3s=";
  };

  propagatedBuildInputs = [ ptyprocess tornado ];

  # test_max_terminals fails
  doCheck = false;

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = "https://github.com/jupyter/terminado";
    license = licenses.bsd2;
  };
}
