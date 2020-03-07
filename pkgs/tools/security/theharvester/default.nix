{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "theHarvester";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = pname;
    rev = "V${version}";
    sha256 = "0lxzxfa9wbzim50d2jmd27i57szd0grm1dfayhnym86jn01qpvn3";
  };

  propagatedBuildInputs = with python3.pkgs; [ 
    aiodns beautifulsoup4 dns grequests netaddr
    plotly pyyaml requests retrying shodan texttable
  ];

  checkInputs = [ python3.pkgs.pytest ];

  checkPhase = "runHook preCheck ; pytest tests/test_myparser.py ; runHook postCheck";
  # We don't run other tests (discovery modules) because they require network access

  meta = with lib; {
    description = "Gather E-mails, subdomains and names from different public sources";
    longDescription = ''
      theHarvester is a very simple, yet effective tool designed to be used in the early
      stages of a penetration test. Use it for open source intelligence gathering and
      helping to determine an entity's external threat landscape on the internet. The tool
      gathers emails, names, subdomains, IPs, and URLs using multiple public data sources.
    '';
    homepage = "https://github.com/laramies/theHarvester";
    maintainers = with maintainers; [ c0bw3b treemo ];
    license = licenses.gpl2;
  };
}
