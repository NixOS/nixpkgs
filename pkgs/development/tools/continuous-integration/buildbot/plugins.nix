{ lib, buildPythonPackage, fetchPypi, callPackage, mock, cairosvg, klein, jinja2, buildbot-pkg }:
{
  # this is exposed for potential plugins to use and for nix-update
  inherit buildbot-pkg;
  www = buildPythonPackage rec {
    pname = "buildbot-www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-W0NRRS0z02/31eyqVRGJUZlUaI77I9WuAI3d3FlWHOQ=";
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
    pname = "buildbot-www-react";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-NfpgTZ0+sP2U8rkf+C4WTpXKVBvO8T+ijs8xIPe49tA=";
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
    pname = "buildbot-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-ykzzvsxP8e0TIHnZJPSnFJoZNNZDvbZ7vZ6hCZyd0iA=";
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
    pname = "buildbot-react-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-U0j/ovoP3A83BzQWF4dtwisJxs00mZz0yyT12mlxfGo=";
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
    pname = "buildbot-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-cu0+66DHf8Hfvfx/IvVyexwl3I0MmLjJrNDBPLxo7Bg=";
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
    pname = "buildbot-react-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-vt7ea0IWIKn4i8sBUUMsoOMi1gPzzFssQ6wORDClJqs=";
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
    pname = "buildbot-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Fd8r2+jV4YSuYu6zUl0fDjEdUGkzuHckR+PTSEyoXio=";
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
    pname = "buildbot-react-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Q8gwqUfMy+D9dPBSw60BhNV12iu9mjhc7KXKYjtO23s=";
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
    pname = "buildbot-wsgi-dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-LzsdHTABtHJzEfkyJ6LbmLE0QmKA3DVjY8VP90O3jT4=";
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
    pname = "buildbot-badges";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-tVMXGYTZlkchfeEcHh3B/wGEZb8xUemtnbFzX65tvb8=";
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
