args: with args;

stdenv.mkDerivation {
  name = "vpnc-0.5.1";
  src = fetchurl {
    url = http://www.unix-ag.uni-kl.de/~massar/vpnc/vpnc-0.5.1.tar.gz;
    sha256 = "f63660bd020bbe6a39e8eb67ad60c54d719046c6198a6834371d098947f9a2ed";
  };

  patches = [ ./makefile.patch ];

  # The `etc/vpnc/vpnc-script' script relies on `which' and on
  # `ifconfig' as found in net-tools (not GNU Inetutils).
  propagatedBuildInputs = [which nettools];

  buildInputs = [libgcrypt perl makeWrapper];

  preConfigure = ''
    substituteInPlace "config.c" \
      --replace "/etc/vpnc/vpnc-script" "$out/etc/vpnc/vpnc-script"

    substituteInPlace "pcf2vpnc" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  postInstall = ''
    for i in $out/{bin,sbin}/*
    do
      wrapProgram $i --prefix PATH :  \
        "${which}/bin:${nettools}/bin:${nettools}/sbin"
    done
  '';

  meta = {
    description = ''VPNC, a virtual private network (VPN) client
                    for Cisco's VPN concentrators'';
    homepage = http://www.unix-ag.uni-kl.de/~massar/vpnc/;
    license = "GPLv2+";
  };
}
