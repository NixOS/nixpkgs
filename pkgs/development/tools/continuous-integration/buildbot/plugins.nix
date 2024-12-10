{
  lib,
  buildPythonPackage,
  fetchPypi,
  callPackage,
  mock,
  cairosvg,
  klein,
  jinja2,
  buildbot-pkg,
}:
{
  # this is exposed for potential plugins to use and for nix-update
  inherit buildbot-pkg;
  www = buildPythonPackage rec {
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-xOsz71kprzKKqvvwpsZTACWf4z+Svx9BQ72xGEZXKdw=";
    };

    # Remove unnecessary circular dependency on buildbot
    postPatch = ''
      sed -i "s/'buildbot'//" setup.py
    '';

    buildInputs = [
      buildbot-pkg
      mock
    ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot UI";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  www-react = buildPythonPackage rec {
    pname = "buildbot_www_react";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-wUiMEAFmqjHXPjnPhsaLWqxvOXyEQIeRBL4W3LB3vkw=";
    };

    # Remove unnecessary circular dependency on buildbot
    postPatch = ''
      sed -i "s/'buildbot'//" setup.py
    '';

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot UI (React)";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2Only;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot_console_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-KerHS5F4b30TvlGeSf6QLUt49S6Iki7O5nex6KPypJY=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  react-console-view = buildPythonPackage rec {
    pname = "buildbot_react_console_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-XrywoVM2ErJ4i7WrRKPRaCOwt5JVDJT6xP7L/Dfv+gk=";
    };

    buildInputs = [ buildbot-pkg ];

    # tests fail
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin (React)";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot_waterfall_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-mhVbuOhe0BrXHbn8bd41Q7I8Xak7fO8ahIK0r113vGY=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  react-waterfall-view = buildPythonPackage rec {
    pname = "buildbot_react_waterfall_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-X89XrjdD0GL7MabLWtkQcdCa4Ain1AGre6mXF/inmck=";
    };

    buildInputs = [ buildbot-pkg ];

    # tests fail
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin (React)";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot_grid_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-YH5SfYuW07Pp00LoBvcDB8MiHB1HzYWg5kQVICrkS5s=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  react-grid-view = buildPythonPackage rec {
    pname = "buildbot_react_grid_view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-rmyAsFCTeIYPdrlWDCxlbjw+BCKwcIaTHlK8KJP0T88=";
    };

    buildInputs = [ buildbot-pkg ];

    # tests fail
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin (React)";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot_wsgi_dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Ls3NJka5vVTx1GW9bnr3jlulj7/pNkX9omXrTIWrwtU=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  react-wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot_react_wsgi_dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-t3LLZJ+kPcowqSyeRcuH3kEjBEiju1MI0z1qhU6KPBs=";
    };

    buildInputs = [ buildbot-pkg ];

    # tests fail
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin (React)";
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  badges = buildPythonPackage rec {
    pname = "buildbot_badges";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-//MftUqUWE2+RpxRPzDEH7tOCN2D1HD8dETZw1OQe5s=";
    };

    buildInputs = [ buildbot-pkg ];
    propagatedBuildInputs = [
      cairosvg
      klein
      jinja2
    ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Badges Plugin";
      maintainers = teams.buildbot.members ++ [ maintainers.julienmalka ];
      license = licenses.gpl2;
    };
  };

}
