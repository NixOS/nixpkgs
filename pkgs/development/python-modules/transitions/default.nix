{ stdenv, buildPythonPackage, fetchPypi
, six, nose, mock, dill, pycodestyle }:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b73015080833b753cbb4a10f51f8234924ddfbdbaf33539fee4e4f3abfff454d";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "dill<0.2.7" dill
  '';

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose mock dill pycodestyle ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pytransitions/transitions;
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
