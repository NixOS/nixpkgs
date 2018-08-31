{ stdenv, pythonPackages, buildbot-pkg }:

{
  www = pythonPackages.buildPythonPackage rec {
    pname = "buildbot_www";
    version = buildbot-pkg.version;

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = pythonPackages.fetchPypi {
      inherit pname version format;
      sha256 = "1m5dsp1gn9m5vfh5hnqp8g6hmhw1f1ydnassd33nhk521f2akz0v";
    };

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    pname = "buildbot-console-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0vblaxmihgb4w9aa5q0wcgvxs7qzajql8s22w0pl9qs494g05s9r";
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
    pname = "buildbot-waterfall-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "18v1a6dapwjc2s9hi0cv3ry3s048w84md908zwaa3033gz3zwzy7";
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
    pname = "buildbot-grid-view";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0iawsy892v6rn88hsgiiwaf689jqzhnb2wbxh6zkz3c0hvq4g0qd";
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
    pname = "buildbot-wsgi-dashboards";
    version = buildbot-pkg.version;

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "00cpjna3bffh1qbq6a3sqffd1g7qhbrmn9gpzxf9k38jam6jgfpz";
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
