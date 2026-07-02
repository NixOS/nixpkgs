{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZNodibNGfCOa8xd3myN+cRa28rY3/ynNUia1kwjTIOU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--pep8 --cov" "" \
      --replace "--cov-report html" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  meta = {
    description = "Simple Signal/Slot implementation";
    homepage = "https://github.com/numergy/signalslot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ myaats ];
  };
}
