{ buildPackages, freebsd-lib }:

# Wrap NetBSD's install
buildPackages.writeShellScriptBin "boot-install" (
  freebsd-lib.install-wrapper
  + ''

    ${buildPackages.coreutils}/bin/install "''${args[@]}"
  ''
)
