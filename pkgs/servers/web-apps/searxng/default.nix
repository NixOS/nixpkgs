{ lib
, python3
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "searxng";
  version = "unstable-2022-02-25";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "33965959b242e25dc20b2a4e69e615e8f8972325";
    sha256 = "sha256-jWWG7T6oobV6iuALMcwlZfCYm6WrT3tk2S+tkrZ3bkA=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    certifi
    lxml
    langdetect
    flask
    redis
    uvloop
    mistletoe
    setproctitle
    flask-babel
    httpx
    python-dateutil
    httpx-socks
    pygments
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
