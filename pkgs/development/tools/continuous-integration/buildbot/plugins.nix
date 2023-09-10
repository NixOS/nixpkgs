{ lib, buildPythonPackage, fetchPypi, callPackage, mock, cairosvg, klein, jinja2, buildbot-pkg }:
{
  # this is exposed for potential plugins to use and for nix-update
  inherit buildbot-pkg;
  www = buildPythonPackage rec {
    pname = "buildbot-www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-fwWzgIf0/+UiKRyiFUKPN4WUbmxQE5sU/ChAOqqLHE4=";
    };

    # Remove unnecessary circular dependency on buildbot
    postPatch = ''
      sed -i "s/'buildbot'//" setup.py
    '';

    buildInputs = [ buildbot-pkg mock ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot UI";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-ghCmbUw/Gj23J5X3fDn/FGkVvXUE9QWrPFTRXSsxEZ4=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-B+xUsZBQWt4TwiBqukHO6o0R0XbjLxbCxQKLaWW0/Fw=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-LFZ3VquRHAHkRcQbw9apOlGlWCK42WT1tPGhW8zSXyo=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ lopsided98 ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot-wsgi-dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-NGI4T0eVV4MxYpD7+BTKbi3r6USt28lXXInrgSd4ASU=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ lopsided98 ];
      license = licenses.gpl2;
    };
  };

  badges = buildPythonPackage rec {
    pname = "buildbot-badges";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-BtKA8zuJEyg3q3GnHS4XSGBLBk3IqCR8NOKui2rIn6Q=";
    };

    buildInputs = [ buildbot-pkg ];
    propagatedBuildInputs = [ cairosvg klein jinja2 ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Badges Plugin";
      maintainers = with maintainers; [ julienmalka ];
      license = licenses.gpl2;
    };
  };

}
