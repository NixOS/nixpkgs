{ lib, iproute2, fetchFromGitHub, fetchpatch }:

iproute2.overrideAttrs (oa: rec {
  pname = "iproute_mptcp";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "iproute-mptcp";
    rev = "mptcp_v${version}";
    sha256 = "07fihvwlaj0ng8s8sxqhd0a9h1narcnp4ibk88km9cpsd32xv4q3";
  };

  preConfigure = oa.preConfigure + ''
    patchShebangs configure
  '';

  patches = [
    # We override "patches" to never apply any iproute2 patches:
  ] ++ [
    # iproute-mptcp patches:

    # Pull upstream fix for -fno-common toolchain support:
    #   https://github.com/multipath-tcp/iproute-mptcp/pull/8
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/multipath-tcp/iproute-mptcp/commit/7aebfde8624c978f6f73b03142892f802d21cc0b.patch";
      sha256 = "098402sjdm10r9xggz6naygnfjs74d9k3s2wc2aczx0d2zayhff8";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/multipath-tcp/iproute-mptcp";
    description = "IP-Route extensions for MultiPath TCP";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ teto ];
    priority = 2;
  };
})
