{ stdenv, lib, buildPackages, fetchFromGitHub, perl, buildLinux, rpiVersion, ... } @ args:

let
  # NOTE: raspberrypifw & raspberryPiWirelessFirmware should be updated with this
  modDirVersion = "5.15.32";
  tag = "1.20220331";
in
lib.overrideDerivation (buildLinux (args // {
  version = "${modDirVersion}-${tag}";
  inherit modDirVersion;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "linux";
    rev = tag;
    hash = "sha256-dJtOXe4yvZz/iu0Ly5F9/E/2GbpTJF/9ZMU3rC1nKMw=";
  };

  defconfig = {
    "1" = "bcmrpi_defconfig";
    "2" = "bcm2709_defconfig";
    "3" = if stdenv.hostPlatform.isAarch64 then "bcmrpi3_defconfig" else "bcm2709_defconfig";
    "4" = "bcm2711_defconfig";
  }.${toString rpiVersion};

  features = {
    efiBootStub = false;
  } // (args.features or {});

  extraConfig = ''
    # ../drivers/gpu/drm/ast/ast_mode.c:851:18: error: initialization of 'void (*)(struct drm_crtc *, struct drm_atomic_state *)' from incompatible pointer type 'void (*)(struct drm_crtc *, struct drm_crtc_state *)' [-Werror=incompatible-pointer-types]
    #   851 |  .atomic_flush = ast_crtc_helper_atomic_flush,
    #       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ../drivers/gpu/drm/ast/ast_mode.c:851:18: note: (near initialization for 'ast_crtc_helper_funcs.atomic_flush')
    DRM_AST n
    # ../drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_commit_tail':
    # ../drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7757:4: error: implicit declaration of function 'is_hdr_metadata_different' [-Werror=implicit-function-declaration]
    #  7757 |    is_hdr_metadata_different(old_con_state, new_con_state);
    #       |    ^~~~~~~~~~~~~~~~~~~~~~~~~
    DRM_AMDGPU n
  '';

  extraMeta = if (rpiVersion < 3) then {
    platforms = with lib.platforms; [ arm ];
    hydraPlatforms = [];
  } else {
    platforms = with lib.platforms; [ arm aarch64 ];
    hydraPlatforms = [ "aarch64-linux" ];
  };
} // (args.argsOverride or {}))) (oldAttrs: {
  postConfigure = ''
    # The v7 defconfig has this set to '-v7' which screws up our modDirVersion.
    sed -i $buildRoot/.config -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
    sed -i $buildRoot/include/config/auto.conf -e 's/^CONFIG_LOCALVERSION=.*/CONFIG_LOCALVERSION=""/'
  '';

  # Make copies of the DTBs named after the upstream names so that U-Boot finds them.
  # This is ugly as heck, but I don't know a better solution so far.
  postFixup = ''
    dtbDir=${if stdenv.isAarch64 then "$out/dtbs/broadcom" else "$out/dtbs"}
    rm $dtbDir/bcm283*.dtb
    copyDTB() {
      cp -v "$dtbDir/$1" "$dtbDir/$2"
    }
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv6l-linux"]) ''
    copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero-w.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
    copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus.dtb
    copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-zero.dtb
    copyDTB bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv7l-linux"]) ''
    copyDTB bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
  '' + lib.optionalString (lib.elem stdenv.hostPlatform.system ["armv7l-linux" "aarch64-linux"]) ''
    copyDTB bcm2710-rpi-zero-2.dtb bcm2837-rpi-zero-2.dtb
    copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
    copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
    copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
    copyDTB bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
  '';
})
