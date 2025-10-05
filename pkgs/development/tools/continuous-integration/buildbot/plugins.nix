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
    format = "setuptools";
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-mn55+Fb2cU2rNB5Nwt41nWXjcZfgd07ijYAAnZnnnwI=";
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
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot_console_view";
    inherit (buildbot-pkg) version;
    format = "setuptools";

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-VA6xqJBjD4XmQabTN8M+PLvfrG7Hq2ooxChtz2jAT8A=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin";
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot_waterfall_view";
    inherit (buildbot-pkg) version;
    format = "setuptools";

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-c/Nmr0Uscalnndq72Y6jPM1JDs5OyOCERtuX/GXkxp8=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin";
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot_grid_view";
    inherit (buildbot-pkg) version;
    format = "setuptools";

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-AmY8RkFX0POmVpW71nNz4+dFbr0FHGhNR3RJymDNoaw=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin";
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot_wsgi_dashboards";
    inherit (buildbot-pkg) version;
    format = "setuptools";

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-vofKxpIfbAs7HR43Y7ojHLQEn6/WIdjZPgZieBMsz74=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin";
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

  badges = buildPythonPackage rec {
    pname = "buildbot_badges";
    inherit (buildbot-pkg) version;
    format = "setuptools";

    src = fetchurl {
      url = "https://github.com/buildbot/buildbot/releases/download/v${version}/${pname}-${version}.tar.gz";
      hash = "sha256-u7HF6X+ClT4rT3LJcTHXWi5oSxCKPXoUDH+QFRI2S0w=";
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
      maintainers = [ maintainers.julienmalka ];
      teams = [ teams.buildbot ];
      license = licenses.gpl2;
    };
  };

}
