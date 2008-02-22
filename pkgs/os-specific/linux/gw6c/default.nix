{stdenv, fetchurl, nettools, openssl, procps}:
stdenv.mkDerivation {
  name = "Gateway6-Client";

  src = fetchurl {
    name = "GateWay6-Client.tar.gz";
    url = http://www.go6.net/4105/file.asp?file_id=142;
    sha256 = "1578i6j3kq7g5f55gy1nksl4q0lxssdk39ilrgqjc20gb6k5j7j3";
  };

  setSourceRoot = "sourceRoot=$(echo tspc*/)";

  preBuild = "sed -e 's@/dev/net/tun@/dev/tun@' -i platform/linux/tsp_tun.c;
	sed -e 's@/sbin/@/var/run/current-system/sw/sbin/@' -i template/linux.sh";

  makeFlags = "target=linux";
  installFlags = "installdir=\$(out)";

  buildInputs = [nettools openssl procps];

  meta = {
    description = "
	Gateway6 client. Provides IPv6 tunnel (by default - using 
	Freenet6 anonymous server, which means dynamic IPv6 address, 
	but if you register at any tunnel broker you can easily 
	enter you data in configuration.nix). You need also to enable
	service \"gw6c\". And check that tun, ipv6 and sit are modprobed.
";
  };
}
