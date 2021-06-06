{ lib, nixosTests, python3, python3Packages, fetchFromGitHub }:

with python3Packages;

toPythonModule (buildPythonApplication rec {
  pname = "searx";
  version = "1.0.0";

  # pypi doesn't receive updates
  src = fetchFromGitHub {
    owner = "searx";
    repo = "searx";
    rev = "v${version}";
    sha256 = "0ghkx8g8jnh8yd46p4mlbjn2zm12nx27v7qflr4c8xhlgi0px0mh";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = [
    Babel
    certifi
    dateutil
    flask
    flaskbabel
    gevent
    grequests
    jinja2
    langdetect
    lxml
    ndg-httpsclient
    pyasn1
    pyasn1-modules
    pygments
    pysocks
    pytz
    pyyaml
    requests
    speaklater
    werkzeug
  ];

  # tests try to connect to network
  doCheck = false;

  pythonImportsCheck = [ "searx" ];

  postInstall = ''
    # Create a symlink for easier access to static data
    mkdir -p $out/share
    ln -s ../${python3.sitePackages}/searx/static $out/share/
  '';

  passthru.tests = { inherit (nixosTests) searx; };

  meta = with lib; {
    homepage = "https://github.com/searx/searx";
    description = "A privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ matejc fpletz globin danielfullmer ];
  };
})
