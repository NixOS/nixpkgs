{ stdenv, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.9.post2";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "1h24fzyr4kfm1nb2627hgg9nl5mwv1gihc3f2wb5000gxmjdasg8";
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
    version = "0.9.9.post2";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = pythonPackages.fetchPypi {
      inherit pname version format;
      sha256 = "1yzk3sy9i8g8wz9vvghhxnafs5dzsd3sybmm8lg043129rh116b9";
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
    version = "0.9.9.post2";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0mmlxzlzl0r97jf0g98m7k1b13mzzy80445i0biazkj0vzkpwxza";
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
    version = "0.9.9.post2";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "0pq45gddwjd61nxmr48cl8s533i4gy3wg9wzbj3g1yb30yrz8qf4";
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
    version = "0.9.9.post2";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "16y7br1yniby8yp932ildn14cxvbw5ywx36d703c4d98dmnlrpaw";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.gpl2;
    };
  };

}
