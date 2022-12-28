{ lib
, fetchFromGitHub
, python3Packages
, prometheus-alertmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PwShGS1rbfZCK5OS6Cnn+mduOpWAD4fC69mcGB5GB1c=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "bs4" "beautifulsoup4"
  '';

  propagatedBuildInputs = [
    prometheus-alertmanager
  ] ++ (with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    beautifulsoup4
    jinja2
    slixmpp
    prometheus-client
    pyyaml
  ]);

  checkInputs = with python3Packages; [
    unittestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "prometheus_xmpp" ];

  meta = {
    description = "XMPP Web hook for Prometheus";
    homepage = "https://github.com/jelmer/prometheus-xmpp-alerts";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
