{ lib, buildPythonApplication, fetchPypi, mail-parser, expiringdict, xmltodict
, lxml, mailsuite, dateparser, geoip2, publicsuffix2, elasticsearch-dsl
, kafka-python, tqdm }:

buildPythonApplication rec {
  pname = "parsedmarc";
  version = "6.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "150drmxxn5m1flb7hqyf9rwrssw28bp2kak0ap8rmpjs8cy47lyl";
  };

  propagatedBuildInputs = [
    mail-parser
    expiringdict
    xmltodict
    lxml
    mailsuite
    dateparser
    geoip2
    publicsuffix2
    elasticsearch-dsl
    kafka-python
    tqdm
  ];

  meta = {
    description =
      "A Python package and CLI for parsing aggregate and forensic DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fadenb ];
  };
}
