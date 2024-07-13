{ lib, buildPythonPackage, fetchurl, callPackage, mock, cairosvg, klein, jinja2, buildbot-pkg }:
{
  # this is exposed for potential plugins to use and for nix-update
  inherit buildbot-pkg;
  www = buildPythonPackage rec {
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-OzH7ckNL09s4r3f6PIc3q9lLT3NgCdIf0IMwJtwlKiY=";
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
      maintainers = teams.buildbot.members;
      license = licenses.gpl2;
    };
  };

  www-react = buildPythonPackage rec {
    pname = "buildbot_www_react";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-lfurzhNJ5DvuPCD/WJ3k+ajuZzhNF6zGOgSuuD0/+Ys=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-uKNqnqUkNkd14/6QcquyWp1v59bNWcTB4s8lRO9hkUc=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-wUrhPbd71F3OfXI5Re1xPnc1/vZxYXxdxX58fnWKjYE=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-qc5mP7V2cOR3SOt224i8HVoAyWHvVYbsqfIQvPjesmE=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-s6L4oF/wTOfM9uKFEJ/mjnQWE6oPRcd32lM1p2ox9+I=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-tZRwDqWYjBwguqA6T3ZoY38+QFogXKiTzbg1qjs/spE=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-t++yXEgM4l40grSVccjx399TM/vUTmQOSInfH+Wqi50=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-MkrMcaf2UeUYjkwcdhj4rhBwEtVESJEMtGa7RArNLz0=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-iCAtKOl/8sfCwa3tsK2oQ+ybs0TVF5uWg4Jv/r7oPWg=";
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-28vj6wUZEnVUSUWrveJ5tdIjN+l4RDewPnm3IVQPXn4=";
    };

    buildInputs = [ buildbot-pkg ];
    propagatedBuildInputs = [ cairosvg klein jinja2 ];

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
