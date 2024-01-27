{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.10";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    hash = "sha256-SqU/K3b8OML3PvFmP7L5R3Ub9vbW66xRpf79mgFZPfc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    vobject
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
    mainProgram = "xandikos";
  };
}
