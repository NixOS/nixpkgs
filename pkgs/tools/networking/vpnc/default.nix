{ stdenv, fetchsvn, nettools, libgcrypt, openssl, openresolv, perl, gawk, makeWrapper }:

stdenv.mkDerivation rec {
  name = "vpnc-0.5.3-post-r550";
  src = fetchsvn {
    url = "http://svn.unix-ag.uni-kl.de/vpnc";
    rev = "550";
    sha256 = "0x4ckfv9lpykwmh28v1kyzz91y1j2v48fi8q5nsawrba4q0wlrls";
  };

  postUnpack = ''
    mv $sourceRoot/trunk/* $sourceRoot/.
    rm -r $sourceRoot/{trunk,branches,tags}
  '';

  patches = [ ./makefile.patch ./no_default_route_when_netmask.patch ];

  # The `etc/vpnc/vpnc-script' script relies on `which' and on
  # `ifconfig' as found in net-tools (not GNU Inetutils).
  propagatedBuildInputs = [ nettools ];

  buildInputs = [libgcrypt perl makeWrapper openssl ];

  preConfigure = ''
    sed -i 's|^#OPENSSL|OPENSSL|g' Makefile

    substituteInPlace "vpnc-script" \
      --replace "which" "type -P" \
      --replace "awk" "${gawk}/bin/awk" \
      --replace "/sbin/resolvconf" "${openresolv}/bin/resolvconf"

    substituteInPlace "config.c" \
      --replace "/etc/vpnc/vpnc-script" "$out/etc/vpnc/vpnc-script"

    substituteInPlace "pcf2vpnc" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  postInstall = ''
    for i in "$out/{bin,sbin}/"*
    do
      wrapProgram $i --prefix PATH :  \
        "${nettools}/bin:${nettools}/sbin"
    done

    mkdir -p $out/share/doc/vpnc
    cp README nortel.txt ChangeLog $out/share/doc/vpnc/
  '';

  meta = {
    homepage = "http://www.unix-ag.uni-kl.de/~massar/vpnc/";
    description = "Virtual private network (VPN) client for Cisco's VPN concentrators";
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.linux;
  };
}
