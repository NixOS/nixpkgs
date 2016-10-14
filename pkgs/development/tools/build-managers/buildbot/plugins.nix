{ stdenv, fetchurl, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.0rc4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0dfdyc3x0926dynzdl9w7z0p84w287l362mxdl3r6wl87gkisr10";
    };

    propagatedBuildInputs = with pythonPackages; [ setuptools ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Packaging Helper";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
      license = licenses.gpl2;
    };
  };

in {

  www = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot_www";
    version = "0.9.0rc4";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/78/45/b43bd85695cd0178f8bac9c3b394062e9eb46f489b655c11e950e54278a2/${name}-py2-none-any.whl";
      sha256 = "0ixi0y0jhbql55swsvy0jin1v6xf4q4mw9p5n9sll2h10lyp9h0p";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
      license = licenses.gpl2;
    };
  };

  console-view = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-console-view";
    version = "0.9.0rc4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "1fig635yg5dgn239g9wzfpw9wc3p91lcl9nnig9k7fijz85pwrva";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
      license = licenses.gpl2;
    };
  };

  waterfall-view = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-waterfall-view";
    version = "0.9.0rc4";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "08kh966grj9b4mif337vv7bqy5ixz8xz31ml63wysjb65djnjbk8";
    };

    propagatedBuildInputs = [ buildbot-pkg ];

    meta = with stdenv.lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      platforms = platforms.all;
      license = licenses.gpl2;
    };
  };
}
