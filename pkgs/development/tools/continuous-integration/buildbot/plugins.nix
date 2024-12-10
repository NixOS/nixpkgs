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
      hash = "sha256-+ZiOkTZLdwqsZfApW6aQxoNkbcFCaB4BHEjMTZIl+Rg=";
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

  console-view = buildPythonPackage rec {
    pname = "buildbot_console_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-IgG/afjU//zrcHuTXMBLlz1gCmB31fWaECIm+UqaMgA=";
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

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot_waterfall_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-E0yFY3PtTZ8XtJGDMh0aRljhTNsWHqHQzcBORTgrCIA=";
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

  grid-view = buildPythonPackage rec {
    pname = "buildbot_grid_view";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-KR4M7RSULCM1aS7vYjWuMXIHGpO+xFjfhC8+YncAmlE=";
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

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot_wsgi_dashboards";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-L7DayDddqrwOyBwgy4w1waCL+49GMtdrCdZNpcLrFXk=";
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

  badges = buildPythonPackage rec {
    pname = "buildbot_badges";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-CnRTSnwhSj6cjrATUuVerGrqt7XxJZYgC5XjUC4+Xrs=";
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
