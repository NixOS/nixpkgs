{ lib
, fetchFromGitHub
, python3Packages
, installShellFiles
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "1x0bylmdizirvlcn6ryd43lffpmlq0cklj3jz956scmxgq4p6wby";
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

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage xandikos.1
  '';

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
