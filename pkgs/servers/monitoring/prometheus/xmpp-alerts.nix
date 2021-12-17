{ lib
, fetchFromGitHub
, python3Packages
, prometheus-alertmanager
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qmmmlcanbrhyyxi32gy3gibgvj7jdjwpa8cf5ci9czvbyxg4rld";
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
