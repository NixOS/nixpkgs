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
      hash = "sha256-xwu260fcRfnUarEW3dnMcl8YheR0YmYCgNQGy7LaDGw=";
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
      hash = "sha256-VtrgDVB+U4uM1SQ1h5IMFwU+nRcleYolDjQYJZ7iHbA=";
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
      hash = "sha256-q4RDjn9i4wHtCctqcNIfilS9SNfS+LHohE0dSMHMOt8=";
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
      hash = "sha256-HrVoSXXo8P05JbJebKQ/bSPTIxQc9gTDT2RJLhJVhO8=";
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
      hash = "sha256-x/a3iAb8vNkplAoS57IX+4BxIcH9roCixrBArUQN+04=";
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
      hash = "sha256-kGH+Wuqn3vkATL8+aKjXbtuBEQro1tekut+7te8abQs=";
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
