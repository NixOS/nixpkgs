{ lib, buildPythonPackage, fetchPypi, callPackage, mock, cairosvg, klein, jinja2, buildbot-pkg }:
{
  # this is exposed for potential plugins to use and for nix-update
  inherit buildbot-pkg;
  www = buildPythonPackage rec {
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-EL5iZ257VXnL+29Jr6r3PVeURX1AcugfZ4RLTjClsXo=";
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

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-5QLw5nXnU+z11E5Tgvu9bbbpCTRpV2zXndukcZPRjtE=";
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
      hash = "sha256-tzqifo9A/KJF9dLpO7jblVaDjx7++v0wLz1Olc79JxI=";
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
      hash = "sha256-fzaqYmaO+vWnQpUvOsPCny3W27atcIHsgeGV6dKEJeg=";
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
      hash = "sha256-BLIs91k8/A4LYMTDgct7TOWFoLU4qK47Javr8qRzkZQ=";
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
      hash = "sha256-dX+tp+WidfLy612+41jz+do/iXQTaIQPcetG8td3jp4=";
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
      hash = "sha256-2kLGdvmf2mnF21gkDCf6h+bhnsxveaNNh95qczRY824=";
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
      hash = "sha256-rIAbk9+6Wi1PCjizHp9p6jpCwaBgBT5Ch1Sa4VKDoww=";
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
      hash = "sha256-D9mjEKFrh+ytNbpuN/06XbiBnKjFLopXfjDg28j7niw=";
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
      hash = "sha256-q3In0IMAIBUjxSzv4LlH9EJukLYJ3WzoEYkFBZB96W8=";
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
      hash = "sha256-TK4KYn3CWxymTsKWeqHr2i5rdO9ZDHvJrb9RqfKNJV4=";
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
