{
  lib,
  config,
  newScope,
  dbus,
  versionCheckHook,
  nushell,
  runCommand,
  rustPlatform,
  cargo,
  cargo-edit,
  jq,
  semver-tool,
}:

lib.makeScope newScope (
  self:

  lib.mapAttrs
    (
      _n: p:
      let
        withNushellVersionAutoPatch = p.overrideAttrs (
          final: prev: {
            cargoDeps =
              (rustPlatform.fetchCargoVendor ({
                inherit (prev) src;
                name = "${prev.pname}-${prev.version}";
                hash = prev.cargoHash;
                nativeBuildInputs = [
                  cargo
                  cargo-edit
                  jq
                  semver-tool
                ];

                postPatch = ''
                  root_cargo_toml="$(cargo locate-project --workspace --message-format=plain)"
                  root_cargo_dir="$(dirname "$root_cargo_toml")"

                  is_compatible() {
                    local name="$1" want="$2"
                    [ -f "$root_cargo_dir/Cargo.lock" ] || return 1

                    local locked="$(
                      cargo metadata --format-version=1 | \
                      jq -r '.packages[] | select(.name=="$name") | .version'
                    )" || return 1
                    [ -z "$locked" ] && return 1

                    case "$(semver diff "$want" "$locked")" in
                      major) return 1 ;;
                      minor) return 1 ;;
                      *) return 0 ;;
                    esac
                  }

                  if is_compatible nu-plugin "${nushell.version}"; then
                    echo "nu-plugin is compatible, no patching needed"
                  else
                    cargo upgrade -p nu-plugin@${nushell.version} -p nu-protocol@${nushell.version}
                    cargo generate-lockfile
                    export NUSHELL_VERSION_UPGRADED=1
                  fi
                '';

                postBuild = ''
                  if ! [ -z "''${NUSHELL_VERSION_UPGRADED}" ]; then
                    cp Cargo.toml $out/Cargo.toml
                  fi
                '';
              })).overrideAttrs
                (old: {
                  buildCommand = old.buildCommand + ''
                    cp $vendorStaging/Cargo.toml $out/Cargo.toml || true
                  '';
                });

            postPatch = ''
              cp ${final.cargoDeps}/Cargo.lock ./Cargo.lock
              cp ${final.cargoDeps}/Cargo.toml ./Cargo.toml || true
            '';
          }
        );

        # add two checks:
        # - `versionCheckhook`, checks wether it's a binary that is able to
        #   display its own version
        # - A check which loads the plugin into the current version of nushell,
        #   to detect incompatibilities (plugins are compiled for very specific
        #   versions of nushell). If this fails, either update the plugin or mark
        #   as broken.
        withChecks = withNushellVersionAutoPatch.overrideAttrs (
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
