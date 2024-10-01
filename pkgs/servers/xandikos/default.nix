{
  fetchFromGitHub,
  fetchpatch2,
  lib,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.11";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "refs/tags/v${version}";
    hash = "sha256-cBsceJ6tib8OYx5L2Hv2AqRS+ADRSLIuJGIULNpAmEI=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-compatibility-with-icalendar-v6.patch";
      url = "https://github.com/jelmer/xandikos/commit/ae8924c374ed86b2efde5bfbc75e56f6d8318086.patch";
      excludes = [ "requirements.txt" ];
      hash = "sha256-PCKo5C6Ejw9ZsFFLAMw1ZtMoCq9gJxR65K7CM6RUYwU=";
    })
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    pytz
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
