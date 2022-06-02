{ lib
, fetchFromGitHub
, python3Packages
, prometheus-alertmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gb7lFRqqw4w/B+Sw0iteDkuGsPfw/ZZ+sRMTu5vxIUo=";
  };

  propagatedBuildInputs = [
    prometheus-alertmanager
  ] ++ (with python3Packages; [
    aiohttp
    slixmpp
    prometheus-client
    pyyaml
  ]);

  checkInputs = with python3Packages; [
    pytz
  ];

  checkPhase = ''
    ${python3Packages.python.interpreter} -m unittest discover
  '';

  meta = {
    description = "XMPP Web hook for Prometheus";
    homepage = "https://github.com/jelmer/prometheus-xmpp-alerts";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
