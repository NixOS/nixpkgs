{ lib, nixosTests, python3, fetchFromGitHub, fetchpatch }:

let
  py = python3.override {
    packageOverrides = self: super: {
      # searx depends on flask-babel@2.0.0; when ran with 3.x it fails with
      # "'Babel' object has no attribute 'localeselector'".
      flask-babel = super.flask-babel.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0";
        src = super.fetchPypi {
          pname = "Flask-Babel";
          inherit version;
          sha256 = "sha256-+fr0XNsuGjLqLsFEA1h9QpUQjzUBenghorGsuM/ZJX0=";
        };
        nativeBuildInputs = [ ];
        format = "setuptools";
        outputs = [ "out" ];
      });
      # Must downgrade babel as well for flask-babel@2.0.0.
      babel = super.babel.overridePythonAttrs (oldAttrs: rec {
        version = "2.11.0";
        src = super.fetchPypi {
          pname = "Babel";
          inherit version;
          hash = "sha256-XvSzImsBgN7d7UIpZRyLDho6aig31FoHMnLzE+TPl/Y=";
        };
        propagatedBuildInputs = [ self.pytz ];
      });
    };
  };
in
with py.pkgs; toPythonModule (buildPythonApplication rec {
  pname = "searx";
  version = "1.1.0";

  # pypi doesn't receive updates
  src = fetchFromGitHub {
    owner = "searx";
    repo = "searx";
    rev = "v${version}";
    sha256 = "sha256-+Wsg1k/h41luk5aVfSn11/lGv8hZYVvpHLbbYHfsExw=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
  '';

  preBuild = ''
    export SEARX_DEBUG="true";
  '';

  propagatedBuildInputs = [
    babel
    certifi
    python-dateutil
    flask
    flask-babel
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
    setproctitle
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
    maintainers = with maintainers; [ matejc globin danielfullmer ];
  };
})
