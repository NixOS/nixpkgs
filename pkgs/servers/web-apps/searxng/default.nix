{ lib
, python3
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "searxng";
  version = "unstable-2022-06-29";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "107006515ee9fe9cad9a6f6387db658953d32486";
    sha256 = "sha256-uV5XiOVuES9wuBx9S8WhM8jhuxRHlSMvW5Ki8WlDwfM=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = with python3Packages; [
    babel
    certifi
    python-dateutil
    flask
    flaskbabel
    brotli
    jinja2
    langdetect
    lxml
    h2
    pygments
    pyyaml
    redis
    uvloop
    setproctitle
    httpx
    httpx-socks
    markdown-it-py
  ];

  # tests try to connect to network
  doCheck = false;

  postInstall = ''
    # Create a symlink for easier access to static data
    mkdir -p $out/share
    ln -s ../${python3.sitePackages}/searx/static $out/share/
  '';

  meta = with lib; {
    homepage = "https://github.com/searxng/searxng";
    description = "A fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kranzes ];
  };
}
