{ lib, iproute2, fetchFromGitHub }:

iproute2.overrideAttrs (oa: rec {
  pname = "iproute_mptcp";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "iproute-mptcp";
    rev = "mptcp_v${version}";
    sha256 = "07fihvwlaj0ng8s8sxqhd0a9h1narcnp4ibk88km9cpsd32xv4q3";
  };

  preConfigure = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile
    patchShebangs configure
  '';

  meta = with lib; {
    homepage = "https://github.com/multipath-tcp/iproute-mptcp";
    description = "IP-Route extensions for MultiPath TCP";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ teto ];
    priority = 2;
  };
})
