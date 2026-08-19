{
  lib,
  buildPythonPackage,
  fetchPypi,
  gevent,
  pytestCheckHook,
  setuptools,
  watchdog,
}:

buildPythonPackage rec {
  pname = "watchdog-gevent";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "watchdog_gevent";
    inherit version;
    hash = "sha256-rmuU0PjIzhxZVs2GX2ErYfRWzxmAF0S7olo0n+jowzc=";
  };

  postPatch = ''
    sed -i setup.cfg \
      -e 's:--cov watchdog_gevent::' \
      -e 's:--cov-report html::'

    substituteInPlace tests/test_observer.py \
      --replace-fail 'events == [FileModifiedEvent(__file__)]' 'FileModifiedEvent(__file__) in events'
  '';

  build-system = [ setuptools ];

  dependencies = [
    gevent
    watchdog
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "watchdog_gevent" ];

  meta = {
    description = "Gevent-based observer for watchdog";
    homepage = "https://github.com/Bogdanp/watchdog_gevent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
