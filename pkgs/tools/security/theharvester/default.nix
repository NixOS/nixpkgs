{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "theharvester";
  version = "4.4.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "laramies";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-L0WbPZE2alregOvWc+0nuMvsD17ayCw3JtahGhf4B1o=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    aiofiles
    aiohttp
    aiomultiprocess
    aiosqlite
    beautifulsoup4
    censys
    certifi
    dnspython
    fastapi
    lxml
    netaddr
    orjson
    plotly
    pyppeteer
    python-dateutil
    pyyaml
    requests
    retrying
    shodan
    slowapi
    starlette
    uvicorn
    uvloop
  ];

  nativeCheckInputs = with  python3.pkgs; [
    pytest
    pytest-asyncio
  ];

  # We don't run other tests (discovery modules) because they require network access
  checkPhase = ''
    runHook preCheck
    pytest tests/test_myparser.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Gather E-mails, subdomains and names from different public sources";
    longDescription = ''
      theHarvester is a very simple, yet effective tool designed to be used in the early
      stages of a penetration test. Use it for open source intelligence gathering and
      helping to determine an entity's external threat landscape on the internet. The tool
      gathers emails, names, subdomains, IPs, and URLs using multiple public data sources.
    '';
    homepage = "https://github.com/laramies/theHarvester";
    changelog = "https://github.com/laramies/theHarvester/releases/tag/${version}";
    maintainers = with maintainers; [ c0bw3b fab treemo ];
    license = licenses.gpl2Only;
  };
}
