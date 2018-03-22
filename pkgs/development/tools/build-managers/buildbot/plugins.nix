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
      sha256 = "0nmrq50c5ib185rpb8ai1mm7gjq2mjvxik1kqrjfa62i1ia9ikyj";
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
      sha256 = "1laz7l7cbbz0czb6skxw314bd2qk2f63qw3n2rs7m7v11gd9cdll";
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
      sha256 = "0mmri8c4n1zwxc1dx2a11yllrmnwqqxjvvil9224lbs98mpchppi";
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
      sha256 = "0nwlw2m3qfifia6gy3d4lrnycra50k98ax071p2zjqknanh563vr";
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
      sha256 = "1zml9bd910zwcby4vr3lmzap2grinha2w5zgb2cmixmz7hfrqswp";
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
