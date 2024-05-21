{ buildPackages, freebsd-lib }:

# Wrap NetBSD's install
buildPackages.writeShellScriptBin "boot-install" (
  freebsd-lib.install-wrapper
  + ''

    ${buildPackages.netbsd.install}/bin/xinstall "''${args[@]}"
  ''
)
