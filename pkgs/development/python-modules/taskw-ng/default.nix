{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  kitchen,
  packaging,
  poetry-core,
  poetry-dynamic-versioning,
  python-dateutil,
  pythonOlder,
  pytz,
  taskwarrior2,
}:

buildPythonPackage rec {
  pname = "taskw-ng";
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "taskw-ng";
    tag = "v${version}";
    hash = "sha256-KxXLSDvUclQlNbMR+Zzl6tgBrH2QxqjLVoyBK3OiKVU=";
  };

  pythonRelaxDeps = [
    "packaging"
    "pytz"
  ];

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    kitchen
    packaging
    python-dateutil
    pytz
  ];

  checkInputs = [ taskwarrior2 ];

  # TODO: doesn't pass because `can_use` fails and `task --version` seems not to be answering.
  # pythonImportsCheck = [ "taskw_ng" ];

  meta = with lib; {
    description = "Module to interact with the Taskwarrior API";
    homepage = "https://github.com/bergercookie/taskw-ng";
    changelog = "https://github.com/bergercookie/taskw-ng/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
