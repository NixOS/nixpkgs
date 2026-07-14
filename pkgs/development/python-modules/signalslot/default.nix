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

buildPythonPackage (finalAttrs: {
  pname = "signalslot";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "signalslot";
    inherit (finalAttrs) version;
    hash = "sha256-ZNodibNGfCOa8xd3myN+cRa28rY3/ynNUia1kwjTIOU=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--pep8 --cov" "" \
      --replace-fail "--cov-report html" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    contexter
    six
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
})
