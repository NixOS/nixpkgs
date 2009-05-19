args : with args; 
let version = "6.0"; in
rec {
  src = fetchurl {
    url = http://go6.net/4105/file.asp?file_id=158;
    sha256 = "0cnxqyw8rdr0sii77n2pv97f0c00dx6ykvnb3mf2acyrarh04nq8";
    name = "gateway6-client-${version}.tar.gz";
  };

  buildInputs = [nettools openssl procps];
  configureFlags = [];
  makeFlags = ["target=linux"];
  installFlags = ["installdir=$out"];

  /* doConfigure should be specified separately */
  phaseNames = ["preBuild" "doMakeInstall"];

  goSrcDir = "cd tspc-advanced";

  preBuild = fullDepEntry (''
    sed -e 's@/dev/net/tun@/dev/tun@' -i platform/linux/tsp_tun.c;
    sed -e 's@/sbin/ifconfig@${nettools}/sbin/ifconfig@' -i template/linux.sh
    sed -e 's@/sbin/route@${nettools}/sbin/route@' -i template/linux.sh
    sed -e 's@/sbin/ip@${iproute}/sbin/ip@' -i template/linux.sh
    sed -e 's@/sbin/sysctl@${procps}/sbin/sysctl@' -i template/linux.sh
  '') ["minInit" "addInputs" "doUnpack"];
      
  name = "gateway6-client-" + version;
  meta = {
    description = "Gateway6 client - provides IPv6 tunnel";
    longDescription = "
      This package provides Gateway6 client (gw6c) daemon,
      which connects to so called tunnel broker via IPv4 
      network, and tunnels IPv6 packets through broker,
      thus giving global IPv6 connectivity. You may need 
      tun, ipv6 and sit modules.
    ";
    homepage = http://go6.net ;
  };
}
