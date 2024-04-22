{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, kitchen
, packaging
, python-dateutil
, pytz
, taskwarrior
}:

buildPythonPackage rec {
  pname = "taskw-ng";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bergercookie";
    repo = "taskw-ng";
    rev = "v${version}";
    hash = "sha256-tlidTt0TzWnvfajYiIfvRv7OfakHY6zWAicmAwq/Z8w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'pytz = "^2023.3.post1"' 'pytz = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [
    kitchen
    packaging
    python-dateutil
    pytz
  ];

  checkInputs = [
    taskwarrior
  ];

  # TODO: doesn't pass because `can_use` fails and `task --version` seems not to be answering.
  # pythonImportsCheck = [ "taskw_ng" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/bergercookie/taskw-ng";
    changelog = "https://github.com/bergercookie/taskw-ng/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
