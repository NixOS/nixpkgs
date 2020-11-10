{ stdenv, buildPythonPackage, fetchPypi
, six, nose, mock, dill, pycodestyle }:

buildPythonPackage rec {
  pname = "transitions";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j3pswbckrhd6plblb0bwzsbvk50nqmxq6dvjclvcr5cljzs7xvg";
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
    homepage = "https://github.com/pytransitions/transitions";
    description = "A lightweight, object-oriented finite state machine implementation in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
