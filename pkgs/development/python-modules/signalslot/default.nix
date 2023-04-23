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
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z26RPNau+4719e82jMhb2LyIR6EvsANI8r3+eKuw494=";
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
