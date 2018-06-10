{stdenv, fetchurl, openssl, nettools, iproute, sysctl}:

let baseName = "gogoclient";
    version  = "1.2";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  src = fetchurl {
    #url = http://gogo6.com/downloads/gogoc-1_2-RELEASE.tar.gz;
    url = http://src.fedoraproject.org/repo/pkgs/gogoc/gogoc-1_2-RELEASE.tar.gz/41177ed683cf511cc206c7782c37baa9/gogoc-1_2-RELEASE.tar.gz;
    sha256 = "a0ef45c0bd1fc9964dc8ac059b7d78c12674bf67ef641740554e166fa99a2f49";
  };
  patches = [./gcc46-include-fix.patch ./config-paths.patch ];
  makeFlags = ["target=linux"];
  installFlags = ["installdir=$(out)"];

  hardeningDisable = [ "format" ];

  buildInputs = [openssl];

  preFixup = ''
    mkdir -p $out/share/${name}
    chmod 444 $out/bin/gogoc.conf
    mv $out/bin/gogoc.conf $out/share/${name}/gogoc.conf.sample
    rm $out/bin/gogoc.conf.sample

    substituteInPlace "$out/template/linux.sh" \
      --replace "/sbin/ifconfig" "${nettools}/bin/ifconfig" \
      --replace "/sbin/route"    "${nettools}/bin/route" \
      --replace "/sbin/ip"       "${iproute}/sbin/ip" \
      --replace "/sbin/sysctl"   "${sysctl}/bin/sysctl"
    sed -i -e 's/^.*Exec \$route -A.*$/& metric 128/' $out/template/linux.sh
  '';

  meta = {
    homepage = http://gogonet.gogo6.com;
    description = "Client to connect to the Freenet6 IPv6 tunnel broker service";
    maintainers = [stdenv.lib.maintainers.bluescreen303];
    platforms = stdenv.lib.platforms.linux;
  };
}
