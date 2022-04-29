{ lib, nettools, fetchFromGitHub  }:

nettools.overrideAttrs(oa: rec {
  pname = "net-tools-mptcp";
  version = "0.95";

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "net-tools";
    rev = "mptcp_v${version}";
    sha256 = "0i7gr1y699nc7j9qllsx8kicqkpkhw51x4chcmyl5xs06b2mdjri";
  };

  meta = with lib; {
    homepage = "https://github.com/multipath-tcp/net-tools";
    description = "A set of tools for controlling the network subsystem in Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ teto ];
  };
})
