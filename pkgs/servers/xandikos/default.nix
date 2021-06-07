{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "sha256-Epy6NWtRY2Oj4MHTStdv8ZJ5SvSmUo6IlwL5PJV9pD0=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    prometheus_client
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
