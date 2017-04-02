{ stdenv, fetchurl, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "09a3yvs5hhf8syrkyydznmymgg86dpvgrwy9rb3bryq00wpjb3wn";
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
    version = "0.9.4";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = pythonPackages.fetchPypi {
      inherit pname version format;
      python = "py2";
      sha256 = "08m4h2pf6hgi8igh2j0qzfq49izc2z0qqj6ddxk0di5l306jx4im";
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
    version = "0.9.4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "1w2vv8iyzl7ak4161avp9n6mhh08adav2fl82bbm17a3064apl8n";
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
    version = "0.9.4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "17xn6vrr0k2xabw6hr9sdyy0ry3llyjfmc79qrpgp5bsly2qv3jf";
    };

    propagatedBuildInputs = with pythonPackages; [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };
}
