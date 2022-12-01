{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, contexter
, eventlet
, mock
, pytestCheckHook
, six
, weakrefmethod
}:

buildPythonPackage rec {
  pname = "signalslot";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z26RPNau+4719e82jMhb2LyIR6EvsANI8r3+eKuw494=";
  };

  propagatedBuildInputs = [
    contexter
    six
    weakrefmethod
  ];

  checkInputs = [
    eventlet
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "signalslot" ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--pep8 --cov" "" \
      --replace "--cov-report html" ""
  '';

  meta = with lib; {
    description = "Simple Signal/Slot implementation";
    homepage = "https://github.com/numergy/signalslot";
    license = licenses.mit;
    maintainers = with maintainers; [ myaats ];
  };
}
