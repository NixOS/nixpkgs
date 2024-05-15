{ buildPackages, freebsd-lib }:

# Wrap GNU coreutils' install
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
