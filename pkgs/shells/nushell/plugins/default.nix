{
  lib,
  config,
  newScope,
  dbus,
  versionCheckHook,
}:

lib.makeScope newScope (
  self:

  lib.mapAttrs
    (
      _n: p:
      p.overrideAttrs {
        doInstallCheck = true;
        nativeInstallCheckInputs = [ versionCheckHook ];
      }
    )
    (
      with self;
      {
        gstat = callPackage ./gstat.nix { };
        formats = callPackage ./formats.nix { };
        polars = callPackage ./polars.nix { };
        query = callPackage ./query.nix { };
        net = callPackage ./net.nix { };
        units = callPackage ./units.nix { };
        highlight = callPackage ./highlight.nix { };
        dbus = callPackage ./dbus.nix {
          inherit dbus;
          nushell_plugin_dbus = self.dbus;
        };
        skim = callPackage ./skim.nix { };
        semver = callPackage ./semver.nix { };
      }
      // lib.optionalAttrs config.allowAliases {
        regex = throw "`nu_plugin_regex` is no longer compatible with the current Nushell release.";
      }
    )
)
