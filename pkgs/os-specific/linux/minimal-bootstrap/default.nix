{
  lib,
  config,
  buildPlatform,
  hostPlatform,
  fetchurl,
  checkMeta,
}:
let
  buildBuildBuildPackages = import ./buildbuildbuild.nix {
    inherit
      lib
      config
      fetchurl
      buildPlatform
      checkMeta
      ;
  };
  buildBuildHostPackages = import ./buildbuildhost.nix {
    inherit
      lib
      config
      fetchurl
      buildPlatform
      hostPlatform
      buildBuildBuildPackages
      buildHostHostPackages
      checkMeta
      ;
  };
  buildHostHostPackages = import ./buildhosthost.nix {
    inherit
      lib
      config
      fetchurl
      buildPlatform
      hostPlatform
      buildBuildBuildPackages
      buildBuildHostPackages
      checkMeta
      ;
  };
in
lib.makeScope
  # Prevent using top-level attrs to protect against introducing dependency on
  # non-bootstrap packages by mistake. Any top-level inputs must be explicitly
  # declared here.
  (
    extra:
    lib.callPackageWith (
      {
        inherit
          lib
          config
          fetchurl
          ;
      }
      // extra
    )
  )
  (self: {
    inherit buildBuildBuildPackages buildBuildHostPackages buildHostHostPackages;
    inherit (buildHostHostPackages)
      bash-static
      binutils-static
      bzip2-static
      coreutils-static
      diffutils-static
      findutils-static
      gawk-static
      gcc
      gnugrep-static
      gnumake-static
      gnupatch-static
      gnused-static
      gnutar-static
      gzip-static
      libc
      linux-headers
      patchelf-static
      xz-static
      ;
    bash = buildHostHostPackages.bash-static;
    requisiteTest =
      let
        runsOnHost = with buildHostHostPackages; [
          bash-static
          binutils-static
          bzip2-static
          coreutils-static
          diffutils-static
          findutils-static
          gawk-static
          gcc
          gnugrep-static
          gnumake-static
          gnupatch-static
          gnused-static
          gnutar-static
          gzip-static
          patchelf-static
          xz-static

          libmpfr
          libgmp
          libmpc
          libc
          libc-headers
          libiberty
          libstdcxx
          libgcc
          libgcc-static
          linux-headers
          gcc-unwrapped
        ];
      in
      buildBuildBuildPackages.bash.runCommand "test-requisites"
        {
          allowedRequisites = runsOnHost;
        }
        ''
          echo ${lib.concatMapStringsSep " " (drv: drv.outPath) runsOnHost} > $out
        '';
  })
