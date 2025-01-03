{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.11";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "refs/tags/v${version}";
    hash = "sha256-cBsceJ6tib8OYx5L2Hv2AqRS+ADRSLIuJGIULNpAmEI=";
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
