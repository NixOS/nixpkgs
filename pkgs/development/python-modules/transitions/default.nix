{ stdenv, buildPythonPackage, fetchPypi
, six, nose, mock, dill, pycodestyle }:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f72b6c5fcac3d1345bbf829e1a48a810255bcb4fc2c11a634af68107c378c1be";
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
