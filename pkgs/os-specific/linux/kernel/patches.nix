{ lib, fetchpatch, fetchurl }:

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

  modinst_arg_list_too_long =
    { name = "modinst-arglist-too-long";
      patch = ./modinst-arg-list-too-long.patch;
    };

  cpu-cgroup-v2 = import ./cpu-cgroup-v2-patches;

  hardened = let
    mkPatch = kernelVersion: { version, sha256, patch }: let src = patch; in {
      name = lib.removeSuffix ".patch" src.name;
      patch = fetchurl (lib.filterAttrs (k: v: k != "extra") src);
      extra = src.extra;
      inherit version sha256;
    };
    patches = lib.importJSON ./hardened/patches.json;
  in lib.mapAttrs mkPatch patches;

  # Adapted for Linux 5.4 from:
  # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=04896832c94aae4842100cafb8d3a73e1bed3a45
  rtl8761b_support =
    { name = "rtl8761b-support";
      patch = ./rtl8761b-support.patch;
    };

  export-rt-sched-migrate = {
    name = "export-rt-sched-migrate";
    patch = ./export-rt-sched-migrate.patch;
  };

  CVE-2023-32233 = rec {
    name = "CVE-2023-32233";
    patch = fetchpatch {
      name = name + ".patch";
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=c1592a89942e9678f7d9c8030efa777c0d57edab";
      hash = "sha256-DYPWgraXPNeFkjtuDYkFXHnCJ4yDewrukM2CCAqC2BE=";
    };
  };

  rust-bindgen-version = rec {
    name = "rust-bindgen-version";
    patch = ./rust-bindgen-version.patch;
  };
  rust-bindgen-0-63-fix = rec {
    name = "rust-bindgen-0.63-fix";
    patch = ./rust-bindgen-0.63-fix.patch;
  };
  rust-bindgen-0-65-fix = rec {
    name = "rust-bindgen-0.65-fix";
    patch = ./rust-bindgen-0.65-fix.patch;
  };
  # easiest way to make the rust-1-68-fix patch apply
  rust-import-alloc-vec-modules = rec {
    name = "rust-import-alloc-vec-modules";
    patch = fetchpatch {
      name = "rust-import-alloc-vec-modules.patch";
      url = "https://github.com/Rust-for-Linux/linux/compare/3c01a424a37fe625052c68c8620f6aa701f77769...318c3cc8e107c2b36108132057ca90d0d56d1bd9.diff";
      hash = "sha256-WNsfWDFZnloDYNH456bAupIq+7stc9hQIZPAhGIGGn4=";
    };
  };
  rust-1-68-fix = rec {
    name = "rust-1.68-fix";
    patch = fetchpatch {
      name = "rust-1.68.patch";
      url = "https://github.com/Rust-for-Linux/linux/commit/3ed03f4da06ede71ac53cf25b9441a372e9f2487.diff";
      hash = "sha256-szbc7YA93VDLFJrgG7V0BDs8q6WxCQhU30Sy33i5FGA=";
      excludes = [
        "scripts/Makefile.build"
        "rust/kernel/init.rs"
        "rust/kernel/lib.rs"
        "rust/uapi/lib.rs"
      ];
    };
  };
  rust-1-70-fix = rec {
    name = "rust-1.70-fix";
    patch = fetchpatch {
      name = "rust-1.70.patch";
      url = "https://github.com/AsahiLinux/linux/commit/496a1b061691f01602aa63d2a8027cf3020d4bb8.diff";
      hash = "sha256-bBhm4gMqVGRNuVecbJKnPfryGsDOJ71qpMo6a6VNDio=";
      # this hunk only applies to downstream asahi changes
      excludes = [ "scripts/Makefile.build" ];
    };
  };
}
