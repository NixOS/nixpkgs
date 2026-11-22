{ buildPackages, freebsd-lib }:

# Wrap GNU coreutils' install
# The -l flag causes a symlink instead of a copy to be installed, so
# it is safe to discard during bootstrap since coreutils does not support it.

buildPackages.writeShellScriptBin "boot-install" (
  freebsd-lib.install-wrapper
  + ''
    fixed_args=()
    while [[ ''${#args[0]} > 0 ]]; do
      case "''${args[0]}" in
        -l)
          args=("''${args[@]:2}")
          continue
      esac
      fixed_args+=("''${args[0]}")
      args=("''${args[@]:1}")
    done

    ${buildPackages.coreutils}/bin/install "''${fixed_args[@]}"
  ''
)
