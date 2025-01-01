{
  lib,
  callPackage,
  pkg-config,
  rustPlatform,
  llvmPackages,
  elfutils,
  zlib,
  fetchFromGitHub,
}:
let
  versionInfo = lib.importJSON ./version.json;
  mkScxScheduler =
    packageType:
    args@{ schedulerName, ... }:
    (if packageType == "rust" then rustPlatform.buildRustPackage else llvmPackages.stdenv.mkDerivation)
      (
        args
        // {
          pname = "${schedulerName}";
          version = args.version or versionInfo.scx.version;

          src = args.src or fetchFromGitHub {
            owner = "sched-ext";
            repo = "scx";
            rev = "refs/tags/v${versionInfo.scx.version}";
            inherit (versionInfo.scx) hash;
          };

          nativeBuildInputs = [
            pkg-config
            llvmPackages.clang
          ] ++ (args.nativeBuildInputs or [ ]);
          buildInputs = [
            elfutils
            zlib
          ] ++ (args.buildInputs or [ ]);

          env.LIBCLANG_PATH = args.env.LIBCLANG_PATH or "${llvmPackages.libclang.lib}/lib";

          # Needs to be disabled in BPF builds
          hardeningDisable = [
            "zerocallusedregs"
          ] ++ (args.hardeningDisable or [ ]);

          meta = args.meta // {
            description = args.meta.description or "";
            longDescription =
              (args.meta.longDescription or "")
              + ''
                \n\nSched-ext schedulers are only available on supported kernels
                              (6.12 and above or any kernel with the scx patchset applied).'';

            homepage = args.meta.homepage or "https://github.com/sched-ext/scx";
            license = args.meta.license or lib.licenses.gpl2Only;
            platforms = args.meta.platforms or lib.platforms.linux;
            maintainers = (args.meta.maintainers or [ ]) ++ (with lib.maintainers; [ johnrtitor ]);
          };
        }
      );

  schedulers = lib.mergeAttrsList [
    { bpfland = import ./scx_bpfland; }
    { lavd = import ./scx_lavd; }
    { layered = import ./scx_layered; }
    { rlfifo = import ./scx_rlfifo; }
    { rustland = import ./scx_rustland; }
    { csheds = import ./scx_csheds.nix; }
  ];
in
(lib.mapAttrs (name: scheduler: callPackage scheduler { inherit mkScxScheduler; }) schedulers)
// {
  inherit mkScxScheduler;
}
