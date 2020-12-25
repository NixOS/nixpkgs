{ lib, fetchpatch, fetchurl }:

{
  bridge_stp_helper =
    { name = "bridge-stp-helper";
      patch = ./bridge-stp-helper.patch;
    };

  request_key_helper =
    { name = "request-key-helper";
      patch = ./request-key-helper.patch;
    };

  request_key_helper_updated =
    { name = "request-key-helper-updated";
      patch = ./request-key-helper-updated.patch;
    };

  p9_fixes =
    { name = "p9-fixes";
      patch = ./p9-fixes.patch;
    };

  modinst_arg_list_too_long =
    { name = "modinst-arglist-too-long";
      patch = ./modinst-arg-list-too-long.patch;
    };

  genksyms_fix_segfault =
    { name = "genksyms-fix-segfault";
      patch = ./genksyms-fix-segfault.patch;
    };

  cpu-cgroup-v2 = import ./cpu-cgroup-v2-patches;

  tag_hardened = {
    name = "tag-hardened";
    patch = ./hardened/tag-hardened.patch;
  };

  hardened = let
    mkPatch = kernelVersion: src: {
      name = lib.removeSuffix ".patch" src.name;
      patch = fetchurl src;
    };
    patches = builtins.fromJSON (builtins.readFile ./hardened/patches.json);
  in lib.mapAttrs mkPatch patches;

  # https://bugzilla.kernel.org/show_bug.cgi?id=197591#c6
  iwlwifi_mvm_support_version_7_scan_req_umac_fw_command = rec {
    name = "iwlwifi_mvm_support_version_7_scan_req_umac_fw_command";
    patch = fetchpatch {
      name = name + ".patch";
      url = "https://bugzilla.kernel.org/attachment.cgi?id=260597";
      sha256 = "09096npxpgvlwdz3pb3m9brvxh7vy0xc9z9p8hh85xyczyzcsjhr";
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/42755
  xen-netfront_fix_mismatched_rtnl_unlock = rec {
    name = "xen-netfront_fix_mismatched_rtnl_unlock";
    patch = fetchpatch {
      name = name + ".patch";
      url = "https://github.com/torvalds/linux/commit/cb257783c2927b73614b20f915a91ff78aa6f3e8.patch";
      sha256 = "0xhblx2j8wi3kpnfpgjjwlcwdry97ji2aaq54r3zirk5g5p72zs8";
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/42755
  xen-netfront_update_features_after_registering_netdev = rec {
    name = "xen-netfront_update_features_after_registering_netdev";
    patch = fetchpatch {
      name = name + ".patch";
      url = "https://github.com/torvalds/linux/commit/45c8184c1bed1ca8a7f02918552063a00b909bf5.patch";
      sha256 = "1l8xq02rd7vakxg52xm9g4zng0ald866rpgm8kjlh88mwwyjkrwv";
    };
  };

  # Adapted for Linux 5.4 from:
  # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=04896832c94aae4842100cafb8d3a73e1bed3a45
  rtl8761b_support =
    { name = "rtl8761b-support";
      patch = ./rtl8761b-support.patch;
    };

  export_kernel_fpu_functions = {
    "4.14" = {
      name = "export_kernel_fpu_functions";
      patch = ./export_kernel_fpu_functions_4_14.patch;
    };
    "5.3" = {
      name = "export_kernel_fpu_functions";
      patch = ./export_kernel_fpu_functions_5_3.patch;
    };
  };

  export-rt-sched-migrate = {
    name = "export-rt-sched-migrate";
    patch = ./export-rt-sched-migrate.patch;
  };

  # patches from https://lkml.org/lkml/2019/7/15/1748
  mac_nvme_t2 = rec {
    name = "mac_nvme_t2";
    patch = ./mac-nvme-t2.patch;
  };
}
