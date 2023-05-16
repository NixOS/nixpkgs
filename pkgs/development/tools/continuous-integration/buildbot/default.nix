{ python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, recurseIntoAttrs
, callPackage
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.40";
<<<<<<< HEAD
        src = fetchPypi {
=======
        src = super.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-RKZgUGCAzJdeHfpXdv5fYxXdxiane1C/Du4YsDieomU=";
        };
<<<<<<< HEAD
        disabledTestPaths = [
           "test/aaa_profiling"
           "test/ext/mypy"
        ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      });
      moto = super.moto.overridePythonAttrs (oldAttrs: rec {
        # a lot of tests -> very slow, we already build them when building python packages
        doCheck = false;
      });
    };
  };

  buildbot-pkg = python.pkgs.callPackage ./pkg.nix {
    inherit buildbot;
  };
  buildbot-worker = python3.pkgs.callPackage ./worker.nix {
    inherit buildbot;
  };
  buildbot = python.pkgs.callPackage ./master.nix {
    inherit buildbot-pkg buildbot-worker buildbot-plugins;
  };
  buildbot-plugins = recurseIntoAttrs (callPackage ./plugins.nix {
    inherit buildbot-pkg;
  });
in
{
  inherit buildbot buildbot-plugins buildbot-worker;
  buildbot-ui = buildbot.withPlugins (with buildbot-plugins; [ www ]);
  buildbot-full = buildbot.withPlugins (with buildbot-plugins; [
    www console-view waterfall-view grid-view wsgi-dashboards badges
  ]);
}
