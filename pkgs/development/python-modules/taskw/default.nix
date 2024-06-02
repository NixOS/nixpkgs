{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,

  # build-system
  setuptools,

  # native dependencies
  pkgs,

  # dependencies
  kitchen,
  python-dateutil,
  pytz,

  # tests
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "taskw";
  version = "2.0.0";
  pyproject = true;

  # ModuleNotFoundError: No module named 'distutils'
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EQm9+b3nqbMqUAejAsh4MD/2UYi2QiWsdKMomkxUi90=";
  };

  patches = [
    ./use-template-for-taskwarrior-install-path.patch
    # Remove when https://github.com/ralphbean/taskw/pull/151 is merged.
    ./support-relative-path-in-taskrc.patch
  ];
  postPatch = ''
    substituteInPlace taskw/warrior.py \
      --replace '@@taskwarrior@@' '${pkgs.taskwarrior}'
  '';

  build-system = [ setuptools ];

  buildInputs = [ pkgs.taskwarrior ];

  dependencies = [
    kitchen
    python-dateutil
    pytz
  ];

  nativeCheckInputs = [ pytest7CheckHook ];

  meta = with lib; {
    homepage = "https://github.com/ralphbean/taskw";
    description = "Python bindings for your taskwarrior database";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pierron ];
  };
}
