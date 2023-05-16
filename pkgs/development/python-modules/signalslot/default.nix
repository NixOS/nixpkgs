{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, contexter
, eventlet
, mock
, pytest-xdist
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "signalslot";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ZNodibNGfCOa8xd3myN+cRa28rY3/ynNUia1kwjTIOU=";
=======
    hash = "sha256-Z26RPNau+4719e82jMhb2LyIR6EvsANI8r3+eKuw494=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--pep8 --cov" "" \
      --replace "--cov-report html" ""
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    contexter
    six
  ];

  pythonRemoveDeps = [
    "weakrefmethod" # needed until https://github.com/Numergy/signalslot/pull/17
  ];

  nativeCheckInputs = [
    eventlet
    mock
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "signalslot" ];

  meta = with lib; {
    description = "Simple Signal/Slot implementation";
    homepage = "https://github.com/numergy/signalslot";
    license = licenses.mit;
    maintainers = with maintainers; [ myaats ];
  };
}
