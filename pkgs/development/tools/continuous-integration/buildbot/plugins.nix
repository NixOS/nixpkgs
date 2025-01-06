{
  lib,
  buildPythonPackage,
  fetchurl,
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

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-pd6ZzrFHKB/acffuM7TxUtXRsZTMIyoUWVqIiilJH/s=";
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

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot UI";
      maintainers = lib.teams.buildbot.members;
      license = lib.licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot_console_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-XfELWX6d4Lat5ByNcsdw9qJd7FjUGL8GRqJkWHKjoTI=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin";
      maintainers = lib.teams.buildbot.members;
      license = lib.licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot_waterfall_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-1osf0WefIjogFk3BqRsX/pjVIzvd18W/NG8LyuFMI/U=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin";
      maintainers = lib.teams.buildbot.members;
      license = lib.licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot_grid_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-3BqQTTj6WPbmHr6bzR4PcVnl8WcTKokY1YHLuwHYqLw=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin";
      maintainers = lib.teams.buildbot.members;
      license = lib.licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot_wsgi_dashboards";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-tZBsyaBhewXs0PWxJMtPJ3yv8Z3dS1wESmJI0beMG28=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = lib.teams.buildbot.members;
      license = lib.licenses.gpl2;
    };
  };

  badges = buildPythonPackage rec {
    pname = "buildbot_badges";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-oQ+exQ4eiF+y9JiYPXbJf9azJVgFZgbBby4MRcBLZgQ=";
    };

    buildInputs = [ buildbot-pkg ];
    propagatedBuildInputs = [
      cairosvg
      klein
      jinja2
    ];

    # No tests
    doCheck = false;

    meta = {
      homepage = "https://buildbot.net/";
      description = "Buildbot Badges Plugin";
      maintainers = lib.teams.buildbot.members ++ [ lib.maintainers.julienmalka ];
      license = lib.licenses.gpl2;
    };
  };

}
