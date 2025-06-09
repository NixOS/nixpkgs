{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "tcxfile";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcgoetz";
    repo = "tcx";
    tag = version;
    hash = "sha256-d1KSeLlaoyXFU8v+8cKu1+2dU2ywvpWqsHBddo/aBC4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    python-dateutil
  ];

  # cannot run built in tests as they lack data files

  pythonImportsCheck = [ "tcxfile" ];

  meta = {
    description = "Python library to read and write Tcx files";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tcgoetz/tcx";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
