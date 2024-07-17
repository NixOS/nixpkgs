{
  stdenv,
  lib,
  fetchurl,
  iptables-legacy,
  libuuid,
  openssl,
  pkg-config,
  which,
  iproute2,
  gnused,
  coreutils,
  gnugrep,
  gawk,
  makeWrapper,
  nixosTests,
  firewall ? "iptables",
  nftables,
  libmnl,
  libnftnl,
}:

let
  scriptBinEnv =
    lib.makeBinPath
      {
        iptables = [
          # needed for dirname in ip{,6}tables_*.sh
          coreutils
          # used in miniupnpd_functions.sh:
          which
          iproute2
          iptables-legacy
          gnused
          gnugrep
          gawk
        ];
        nftables = [
          # needed for dirname in nft_*.sh & cat in nft_init.sh
          coreutils
          # used in miniupnpd_functions.sh:
          which
          nftables
        ];
      }
      .${firewall};
in
stdenv.mkDerivation rec {
  pname = "miniupnpd";
  version = "2.3.6";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/miniupnpd-${version}.tar.gz";
    sha256 = "sha256-Ecp79NS6bGuhLHDDBBgH9Rb02fa2aXvqBOg3YmudZ5w=";
  };

  buildInputs =
    [
      iptables-legacy
      libuuid
      openssl
    ]
    ++ lib.optionals (firewall == "nftables") [
      libmnl
      libnftnl
    ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # ./configure is not a standard configure file, errors with:
  # Option not recognized : --prefix=
  dontAddPrefix = true;
  configureFlags = [
    "--firewall=${firewall}"
    # allow using various config options
    "--ipv6"
    "--leasefile"
    "--regex"
    "--vendorcfg"
    # hardening
    "--portinuse"
  ];

  installFlags = [
    "PREFIX=$(out)"
    "INSTALLPREFIX=$(out)"
  ];

  postFixup =
    {
      # Ideally we'd prefer using system's config.firewall.package here for iptables,
      # however for some reason switching --prefix to --suffix breaks the script
      iptables = ''
        for script in $out/etc/miniupnpd/ip{,6}tables_{init,removeall}.sh
        do
          wrapProgram $script --prefix PATH : '${scriptBinEnv}:$PATH'
        done
      '';
      nftables = ''
        for script in $out/etc/miniupnpd/nft_{delete_chain,flush,init,removeall}.sh
        do
          wrapProgram $script --suffix PATH : '${scriptBinEnv}:$PATH'
        done
      '';
    }
    .${firewall};

  passthru.tests = {
    bittorrent-integration = nixosTests.bittorrent;
    inherit (nixosTests) upnp;
  };

  meta = with lib; {
    homepage = "https://miniupnp.tuxfamily.org/";
    description = "A daemon that implements the UPnP Internet Gateway Device (IGD) specification";
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "miniupnpd";
  };
}
