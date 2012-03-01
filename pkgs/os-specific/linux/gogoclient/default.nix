{stdenv, fetchurl, openssl, nettools, iproute, procps}:

let baseName = "gogoclient";
    version  = "1.2";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = http://gogo6.com/downloads/gogoc-1_2-RELEASE.tar.gz;
    sha256 = "a0ef45c0bd1fc9964dc8ac059b7d78c12674bf67ef641740554e166fa99a2f49";
  };
  patches = [./gcc46-include-fix.patch ./config-paths.patch ];
  makeFlags = ["target=linux"];
  installFlags = ["installdir=$(out)"];

  buildInputs = [openssl];

  preFixup = ''
    ensureDir $out/share/${name}
    chmod 444 $out/bin/gogoc.conf
    mv $out/bin/gogoc.conf $out/share/${name}/gogoc.conf.sample
    rm $out/bin/gogoc.conf.sample

    substituteInPlace "$out/template/linux.sh" \
      --replace "/sbin/ifconfig" "${nettools}/sbin/ifconfig" \
      --replace "/sbin/route"    "${nettools}/sbin/route" \
      --replace "/sbin/ip"       "${iproute}/sbin/ip" \
      --replace "/sbin/sysctl"   "${procps}/sbin/sysctl"
  '';

  meta = {
    homepage = http://gogonet.gogo6.com;
    description = "Client to connect to the Freenet6 IPv6 tunnel broker service";
    maintainers = [stdenv.lib.maintainers.bluescreen303];
  };
}
