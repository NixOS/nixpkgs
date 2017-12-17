{ stdenv, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.15.post1";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0gsa5fi1gkwnz8dsrl2s5kzcfawnj3nl8g8h6z1winz627l9n8sh";
    };

    propagatedBuildInputs = with pythonPackages; [ setuptools ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Packaging Helper";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

in {
  www = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot_www";
    version = buildbot-pkg.version;

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = pythonPackages.fetchPypi {
      inherit pname version format;
      sha256 = "19cnzp5prima3jrk525xspw7vqc5pjln2nihj4kc3w90dhzllj8x";
    };

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-console-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "1j6aw2j2sl7ix8rb67pbs6nfvv8v3smgkvqzsjsyh5sdfr2663cg";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-waterfall-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0k0wd4rq034bij2flfjv60h8czkfn836bnaa7hwsrl58gxds39m4";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  grid-view = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-grid-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "08ng56jmy50s3zyn6wxizji1zhgzhi65z7w3wljg02qrbd5688gj";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-wsgi-dashboards";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "15fm72yymv873n3vsw9kprypcf6jzln18v4lb062n8lqw9pykwb1";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ akazakov ];
      license = licenses.gpl2;
    };
  };

}
