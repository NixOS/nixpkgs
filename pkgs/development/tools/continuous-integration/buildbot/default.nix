{ lib
, newScope
, python3
, fetchPypi
, recurseIntoAttrs
}:
# Take packages from self first, then python.pkgs (and secondarily pkgs)
lib.makeScope (self: newScope (self.python.pkgs // self)) (self: {
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.49";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-Bv8ly64ww5bEt3N0ZPKn/Deme32kCZk7GCsCTOyArtk=";
        };
        disabledTestPaths = [
           "test/aaa_profiling"
           "test/ext/mypy"
        ];
      });
      moto = super.moto.overridePythonAttrs (oldAttrs: {
        # a lot of tests -> very slow, we already build them when building python packages
        doCheck = false;
      });
    };
  };

  buildbot-pkg = self.callPackage ./pkg.nix { };

  buildbot-worker = self.callPackage ./worker.nix { };

  buildbot = self.callPackage ./master.nix { };

  buildbot-plugins = recurseIntoAttrs (self.callPackage ./plugins.nix { });

  buildbot-ui = self.buildbot.withPlugins (with self.buildbot-plugins; [ www ]);

  buildbot-full = self.buildbot.withPlugins (with self.buildbot-plugins; [
    www console-view waterfall-view grid-view wsgi-dashboards badges
  ]);
})
