{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  gevent,
  pytestCheckHook,
  setuptools,
  pythonOlder,
  watchdog,
}:

buildPythonPackage rec {
  pname = "watchdog-gevent";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bogdanp";
    repo = "watchdog_gevent";
    rev = "refs/tags/v${version}";
    hash = "sha256-FESm3fNuLmOg2ilI/x8U9LuAimHLnahcTHYzW/nzOVY=";
  };

  patches = [
    # Add new event_filter argument to GeventEmitter
    (fetchpatch {
      name = "new-event_filter-argument.patch";
      url = "https://github.com/Bogdanp/watchdog_gevent/commit/a98b6599aefb6f1ea6f9682485ed460c52f6e55f.patch";
      hash = "sha256-lbUtl8IbnJjlsIpbC+wXLvYB+ZtUuHWqFtf31Bfqc2I=";
    })
  ];

  postPatch = ''
    sed -i setup.cfg \
      -e 's:--cov watchdog_gevent::' \
      -e 's:--cov-report html::'
  '';

  build-system = [ setuptools ];

  dependencies = [
    gevent
    watchdog
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "watchdog_gevent" ];

  meta = with lib; {
    description = "Gevent-based observer for watchdog";
    homepage = "https://github.com/Bogdanp/watchdog_gevent";
    license = licenses.asl20;
    maintainers = with maintainers; [ traxys ];
  };
}
