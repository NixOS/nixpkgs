{
  lib,
  fetchpatch,
  fetchurl,
}:

{
  ath_regd_optional = rec {
    name = "ath_regd_optional";
    patch = fetchpatch {
      name = name + ".patch";
      url = "https://github.com/openwrt/openwrt/raw/ed2015c38617ed6624471e77f27fbb0c58c8c660/package/kernel/mac80211/patches/ath/402-ath_regd_optional.patch";
      sha256 = "1ssDXSweHhF+pMZyd6kSrzeW60eb6MO6tlf0il17RC0=";
      postFetch = ''
        sed -i 's/CPTCFG_/CONFIG_/g' $out
        sed -i '/--- a\/local-symbols/,$d' $out
      '';
    };
  };

  bridge_stp_helper = {
    name = "bridge-stp-helper";
    patch = ./bridge-stp-helper.patch;
  };

  # Reverts the buggy commit causing https://bugzilla.kernel.org/show_bug.cgi?id=217802
  dell_xps_regression = {
    name = "dell_xps_regression";
    patch = fetchpatch {
      name = "Revert-101bd907b424-misc-rtsx-judge-ASPM-Mode-to-set.patch";
      url = "https://raw.githubusercontent.com/openSUSE/kernel-source/1b02b1528a26f4e9b577e215c114d8c5e773ee10/patches.suse/Revert-101bd907b424-misc-rtsx-judge-ASPM-Mode-to-set.patch";
      hash = "sha256-RHJdQ4p0msTOVPR+/dYiKuwwEoG9IpIBqT4dc5cJjf8=";
    };
  };

  request_key_helper = {
    name = "request-key-helper";
    patch = ./request-key-helper.patch;
  };

  request_key_helper_updated = {
    name = "request-key-helper-updated";
    patch = ./request-key-helper-updated.patch;
  };

  hardened =
    let
      mkPatch =
        kernelVersion:
        {
          version,
          sha256,
          patch,
        }:
        let
          src = patch;
        in
        {
          name = lib.removeSuffix ".patch" src.name;
          patch = fetchurl (lib.filterAttrs (k: v: k != "extra") src);
          extra = src.extra;
          inherit version sha256;
        };
      patches = lib.importJSON ./hardened/patches.json;
    in
    lib.mapAttrs mkPatch patches;

  # Adapted for Linux 5.4 from:
  # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=04896832c94aae4842100cafb8d3a73e1bed3a45
  rtl8761b_support = {
    name = "rtl8761b-support";
    patch = ./rtl8761b-support.patch;
  };

  export-rt-sched-migrate = {
    name = "export-rt-sched-migrate";
    patch = ./export-rt-sched-migrate.patch;
  };
}
