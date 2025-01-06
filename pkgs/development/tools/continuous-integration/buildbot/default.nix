{
  lib,
  newScope,
  python3,
  recurseIntoAttrs,
  fetchFromGitHub,
}:
# Take packages from self first, then python.pkgs (and secondarily pkgs)
lib.makeScope (self: newScope (self.python.pkgs // self)) (self: {
  python = python3.override {
    self = self.python;
    packageOverrides = self: super: {
      service-identity = super.service-identity.overridePythonAttrs (oldAttrs: {
        version = "24.2.0";
        src = fetchFromGitHub {
          owner = "pyca";
          repo = "service-identity";
          tag = "24.2.0";
          hash = "sha256-onxCUWqGVeenLqB5lpUpj3jjxTM61ogXCQOGnDnClT4=";
        };
        checkInputs = [ super.pyopenssl ];
      });
    };
  };

  buildbot-pkg = self.callPackage ./pkg.nix { };

  buildbot-worker = self.callPackage ./worker.nix { };

  buildbot = self.callPackage ./master.nix { };

  buildbot-plugins = recurseIntoAttrs (self.callPackage ./plugins.nix { });

  buildbot-ui = self.buildbot.withPlugins (with self.buildbot-plugins; [ www ]);

  buildbot-full = self.buildbot.withPlugins (
    with self.buildbot-plugins;
    [
      www
      console-view
      waterfall-view
      grid-view
      wsgi-dashboards
      badges
    ]
  );
})
