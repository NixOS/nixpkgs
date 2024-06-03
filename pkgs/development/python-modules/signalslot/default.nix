{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  contexter,
  eventlet,
  mock,
  pytest-xdist,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "signalslot";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZNodibNGfCOa8xd3myN+cRa28rY3/ynNUia1kwjTIOU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--pep8 --cov" "" \
      --replace "--cov-report html" ""
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
