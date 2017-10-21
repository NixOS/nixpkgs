{ stdenv, pythonPackages }:

let
  buildbot-pkg = pythonPackages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "buildbot-pkg";
    version = "0.9.11";

    src = pythonPackages.fetchPypi {
      inherit pname version;
      sha256 = "1gh7wj9z7n7yfs219jbv9pdd2w8dwj6qpa090ffjkfpgd3xana33";
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
      sha256 = "0fk1swdncg4nha744mzkf6jqh1zv1cfhnqvd19669kjcyjx9i68d";
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
      sha256 = "16wxgnh35916c2gw34971ynx319lnm9addhqvii885vid44pqim0";
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
      sha256 = "1hcr8xsc0ajfg2vz2h8g5s8ypsp32kdplgqp21jh8z5y0a6nzqsl";
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
      sha256 = "0aw1073xq549q5jkjk31zhqpasp8jiy4gch0fjyw8qy0dax8hc7r";
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
      sha256 = "0x99mdmn1ngcnmkxr40hwqafsq48jybdz45y5kpc0yw68n0bfwmv";
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
