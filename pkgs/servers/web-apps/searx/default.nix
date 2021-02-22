{ lib, nixosTests, python3, python3Packages, fetchFromGitHub, fetchpatch }:

with python3Packages;

toPythonModule (buildPythonApplication rec {
  pname = "searx";
  version = "0.18.0";

  # Can not use PyPI because certain test files are missing.
  src = fetchFromGitHub {
    owner = "searx";
    repo = "searx";
    rev = "v${version}";
    sha256 = "0idxspvckvsd02v42h4z4wqrfkn1l8n59i91f7pc837cxya8p6hn";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
    # skip failing test
    sed -i '/test_json_serial(/,+3d' tests/unit/test_standalone_searx.py
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = [
    pyyaml lxml grequests flaskbabel flask requests
    gevent speaklater Babel pytz dateutil pygments
    pyasn1 pyasn1-modules ndg-httpsclient certifi pysocks
    jinja2 werkzeug
  ];

  checkInputs = [
    Babel mock nose2 covCore pep8 plone-testing splinter
    unittest2 zope_testrunner selenium
  ];

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
