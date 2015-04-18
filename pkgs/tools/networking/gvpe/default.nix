a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    openssl gmp zlib
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [
    "--enable-tcp"
    "--enable-http-proxy"
    "--enable-dns"
    ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "preBuild" "doMakeInstall"];
  preBuild = a.fullDepEntry (''
    sed -e 's@"/sbin/ifconfig.*"@"${a.iproute}/sbin/ip link set $IFNAME address $MAC mtu $MTU"@' -i src/device-linux.C
    sed -e 's@/sbin/ifconfig@${a.nettools}/sbin/ifconfig@g' -i src/device-*.C
  '') ["minInit" "doUnpack"];
      
  meta = {
    description = "A proteted multinode virtual network";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; linux ++ freebsd;
  };
}
