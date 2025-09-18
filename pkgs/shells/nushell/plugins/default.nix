{
  lib,
  config,
  newScope,
  dbus,
  versionCheckHook,
  nushell,
  runCommand,
}:

lib.makeScope newScope (
  self:

  lib.mapAttrs
    (
      _n: p:
      let
        # add two checks:
        # - `versionCheckhook`, checks wether it's a binary that is able to
        #   display its own version
        # - A check which loads the plugin into the current version of nushell,
        #   to detect incompatibilities (plugins are compiled for very specific
        #   versions of nushell). If this fails, either update the plugin or mark
        #   as broken.
        withChecks = p.overrideAttrs (
          final: _prev: {
            doInstallCheck = true;
            nativeInstallCheckInputs = [ versionCheckHook ];

            passthru.tests.loadCheck =
              let
                nu = lib.getExe nushell;
                plugin = lib.getExe withChecks;
              in
              runCommand "test-load-${final.pname}" { } ''
                touch $out
                ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
                ${nu} -n -c "plugin use --plugin-config $out ${plugin}"
              '';
          }
        );
      in
      withChecks
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
        };
        skim = callPackage ./skim.nix { };
        semver = callPackage ./semver.nix { };
        hcl = callPackage ./hcl.nix { };
        desktop_notifications = callPackage ./desktop_notifications.nix { };
      }
      // lib.optionalAttrs config.allowAliases {
        regex = throw "`nu_plugin_regex` is no longer compatible with the current Nushell release.";
      }
    )
)
