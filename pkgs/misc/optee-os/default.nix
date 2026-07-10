{
  dtc,
  fetchFromGitHub,
  lib,
  nukeReferences,
  pkgsBuildBuild,
  stdenv,
}:

let
  defaultVersion = "4.7.0";

  defaultSrc = fetchFromGitHub {
    owner = "OP-TEE";
    repo = "optee_os";
    rev = defaultVersion;
    hash = "sha256-kvp3GDBZtKlephyW+oxHmXnqvCe1jL+PN1i/MCw6SX0=";
  };

  buildOptee = lib.makeOverridable (
    {
      version ? null,
      src ? null,
      platform,
      extraMakeFlags ? [ ],
      extraMeta ? { },
      ...
    }@args:

    let
      inherit (stdenv.hostPlatform) is32bit is64bit;

      taTarget =
        {
          "arm" = "ta_arm32";
          "arm64" = "ta_arm64";
        }
        .${stdenv.hostPlatform.linuxArch};
    in
    stdenv.mkDerivation (
      {
        pname = "optee-os-${platform}";

        version = if src == null then defaultVersion else version;

        src = if src == null then defaultSrc else src;

        postPatch = ''
          patchShebangs $(find -type d -name scripts -printf '%p ')
        '';

        outputs = [
          "out"
          "devkit"
        ];

        strictDeps = true;

        enableParallelBuilding = true;

        depsBuildBuild = [ pkgsBuildBuild.stdenv.cc ];

        nativeBuildInputs = [
          dtc
          nukeReferences
          (pkgsBuildBuild.python3.withPackages (
            p: with p; [
              pyelftools
              cryptography
            ]
          ))
        ];

        makeFlags = [
          "O=out"
          "PLATFORM=${platform}"
          "CFG_USER_TA_TARGETS=${taTarget}"
        ]
        ++ (lib.optionals is32bit [
          "CFG_ARM32_core=y"
          "CROSS_COMPILE32=${stdenv.cc.targetPrefix}"
        ])
        ++ (lib.optionals is64bit [
          "CFG_ARM64_core=y"
          "CROSS_COMPILE64=${stdenv.cc.targetPrefix}"
        ])
        ++ extraMakeFlags;

        installPhase = ''
          runHook preInstall

          mkdir -p $out
          cp out/core/{tee.elf,tee-pageable_v2.bin,tee.bin,tee-header_v2.bin,tee-pager_v2.bin,tee-raw.bin} $out
          nuke-refs $out/*

          cp -r out/export-${taTarget} $devkit

          runHook postInstall
        '';

        # The conventional build system for OPTEE trusted applications accepts
        # a TA_DEV_KIT_DIR parameter, which expects all artifacts (headers and
        # libraries) to exist in that directory. We populate a "devkit" Nix
        # output for this purpose, but we must also tell the multiple-output
        # setup hook to not move our artifacts after we populate this
        # directory.
        outputDev = "devkit";
        outputLib = "devkit";

        meta = {
          description = "Trusted Execution Environment for ARM";
          homepage = "https://github.com/OP-TEE/optee_os";
          changelog = "https://github.com/OP-TEE/optee_os/blob/${defaultVersion}/CHANGELOG.md";
          license = lib.licenses.bsd2;
          maintainers = [ lib.maintainers.jmbaur ];
        }
        // extraMeta;
      }
      // removeAttrs args [ "extraMeta" ]
    )
  );
in
{
  inherit buildOptee;

  opteeQemuArm = buildOptee {
    platform = "vexpress";
    extraMakeFlags = [ "PLATFORM_FLAVOR=qemu_virt" ];
    extraMeta.platforms = [ "armv7l-linux" ];
  };

  opteeQemuAarch64 = buildOptee {
    platform = "vexpress";
    extraMakeFlags = [ "PLATFORM_FLAVOR=qemu_armv8a" ];
    extraMeta.platforms = [ "aarch64-linux" ];
  };
}
