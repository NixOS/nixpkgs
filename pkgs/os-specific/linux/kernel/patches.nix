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

  request_key_helper = {
    name = "request-key-helper";
    patch = ./request-key-helper.patch;
  };

  libbpf_C23_compat = {
    name = "c23-compat-libbpf";
    patch = ./C23-compat-6.1.patch;
  };

  # https://lore.kernel.org/netdev/20261022104217.1852191-1-pointerliu@126.com/ (Cc stable, not yet in a release)
  skb_zerocopy_shared_frag = {
    name = "skb-zerocopy-shared-frag";
    patch = fetchpatch {
      name = "net-skbuff-propagate-shared-frag-marker-in-skb_zerocopy.patch";
      url = "https://lore.kernel.org/netdev/20261022104217.1852191-1-pointerliu@126.com/raw";
      hash = "sha256-0fTpxTOPLIQfivQqogjuhZGwo9lPMQ/vhDwTwxGsUwU=";
    };
  };

  # Same fix, context adjusted for kernels before 7.3 (no from->unreadable check after the frag loop)
  skb_zerocopy_shared_frag_pre_7_3 = {
    name = "skb-zerocopy-shared-frag-pre-7.3";
    patch = ./skb-zerocopy-shared-frag-pre-7.3.patch;
  };
}
