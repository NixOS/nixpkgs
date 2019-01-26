{ stdenv, buildPythonPackage, fetchPypi
, six, nose, mock, dill, pycodestyle }:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.6.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afe0f498cf1f3f3b0fc13562011b8895a172df8f891dbb5118923d46e78a96d7";
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
