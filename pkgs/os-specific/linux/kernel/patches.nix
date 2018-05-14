{ stdenv, fetchurl, fetchpatch, pkgs }:

rec {
  bridge_stp_helper =
    { name = "bridge-stp-helper";
      patch = ./bridge-stp-helper.patch;
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

  tag_hardened = rec {
    name = "tag-hardened";
    patch = ./tag-hardened.patch;
  };

  # https://bugzilla.kernel.org/show_bug.cgi?id=197591#c6
  iwlwifi_mvm_support_version_7_scan_req_umac_fw_command = rec {
    name = "iwlwifi_mvm_support_version_7_scan_req_umac_fw_command";
    patch = fetchpatch {
      name = name + ".patch";
      url = https://bugzilla.kernel.org/attachment.cgi?id=260597;
      sha256 = "09096npxpgvlwdz3pb3m9brvxh7vy0xc9z9p8hh85xyczyzcsjhr";
    };
  };

  # https://patchwork.kernel.org/patch/9626797/
  # Should be included in 4.17, so this patch can be dropped when 4.16 becomes obsolete.
  bcm2835_mmal_v4l2_camera_driver = rec {
    name = "bcm2835_mmal_v4l2_camera_driver";
    patch = fetchpatch {
      name = name + ".patch";
      url = https://patchwork.kernel.org/patch/9626797/raw/;
      sha256 = "0iwb0yxsf95zv4qxkvlvhqfmzx0rk13g9clvxsharvwkb4w5lwa0";
    };
  };

}
