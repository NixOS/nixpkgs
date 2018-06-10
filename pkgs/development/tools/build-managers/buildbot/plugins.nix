{ stdenv, pythonPackages, buildbot-pkg }:

{
  www = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot_www";
    version = buildbot-pkg.version;

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = pythonPackages.fetchPypi {
      inherit pname version format;
      sha256 = "01v9w8iy9q6fwrmz6db7fanjixax7whn74k67bj0czrbjjkpfzvb";
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
      sha256 = "1cwxkzpgwzk9b361rj980bbnmhzzsr46pgf94zqpg3na8xm6hpwj";
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
      sha256 = "0ival58f50128315d0nck63pzya2zm7q6hvgmxfbjl0my8il9p2l";
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
      sha256 = "0jiwfb699nqbmpcm88y187ig4ha6p7d4v98mjwa9blhm54dk8kh1";
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
      sha256 = "00mfn24gbwr2p3n7nsijzv949l7hiksiafhma18nnh40r8f4l5f2";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ ];
      license = licenses.gpl2;
    };
  };

}
