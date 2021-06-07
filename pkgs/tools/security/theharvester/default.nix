{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "theHarvester";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = pname;
    rev = version;
    sha256 = "02jhk34znpvq522pqr3x4c0rljw37x62znwycijf1zx81dpbn4rm";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    aiohttp
    aiomultiprocess
    aiosqlite
    beautifulsoup4
    censys
    certifi
    dns
    gevent
    grequests
    lxml
    netaddr
    plotly
    pyppeteer
    pyyaml
    requests
    retrying
    shodan
    texttable
    uvloop
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
    license = licenses.gpl2Only;
  };
}
