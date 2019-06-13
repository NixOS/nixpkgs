{ lib
, buildPythonPackage
, fetchPypi
, ptyprocess
, tornado
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de08e141f83c3a0798b050ecb097ab6259c3f0331b2f7b7750c9075ced2c20c2";
  };

  propagatedBuildInputs = [ ptyprocess tornado ];

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = https://github.com/jupyter/terminado;
    license = licenses.bsd2;
  };
}
