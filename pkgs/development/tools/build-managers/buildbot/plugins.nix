{ stdenv, fetchurl, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.0.post1";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0frmnc73dsyc9mjnrnpm4vdrwb7c63gc6maq6xvlp486v7sdhjbi";
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
    version = "0.9.0.post1";

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = fetchurl {
      url = "https://pypi.python.org/packages/02/d0/fc56ee27a09498638a47dcc5637ee5412ab7a67bfb4b3ff47e041f3d7b66/${name}-py2-none-any.whl";
      sha256 = "14ghch67k6090736n89l401swz7r9hnk2zlmdb59niq8lg7dyg9q";
    };

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
    version = "0.9.0.post1";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0dc7rb7mrpva5gj7l57i96a78d6yj28pkkj9hfim1955z9dgn58l";
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
    version = "0.9.0.post1";

    src = fetchurl {
      url = "mirror://pypi/b/${pname}/${name}.tar.gz";
      sha256 = "0x9vvw15zzgj4w3qcxh8r10rb36ni0qh1215y7wbawh5lggnjm0g";
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
