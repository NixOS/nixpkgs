{ lib, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = version;
    sha256 = "17aq6v4ahnga82r350kx1y8i7zgikpzmwzaacj7a339kh8hxkh63";
  };

  propagatedBuildInputs = with pythonPackages; [ slixmpp prometheus_client pyyaml ];

  meta = {
    description = "XMPP Web hook for Prometheus";
    homepage = "https://github.com/jelmer/prometheus-xmpp-alerts";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
