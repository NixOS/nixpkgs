{ lib, stdenv, fetchurl, darwin, python3 }:

stdenv.mkDerivation rec {
  pname = "iproute2mac";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/brona/iproute2mac/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "1drk2b2nssb9ahw6mnss9sv12qlhvp5k8jdhzman65jy1xmwxvrz";
  };

  buildInputs = [ python3 ];

  __impureHostDeps = [ "/usr/bin/sudo" ];

  postPatch = with darwin; ''
    substituteInPlace src/ip.py \
      --replace /sbin/ifconfig ${network_cmds}/bin/ifconfig \
      --replace /sbin/route ${network_cmds}/bin/route \
      --replace /usr/sbin/netstat ${network_cmds}/bin/netstat \
      --replace /usr/sbin/ndp ${network_cmds}/bin/ndp \
      --replace /usr/sbin/arp ${network_cmds}/bin/arp \
      --replace /usr/sbin/networksetup ${network_cmds}/bin/networksetup
  '';

  installPhase = ''
    install -D -m 755 src/ip.py $out/bin/ip
  '';

  meta = with lib; {
    homepage = "https://github.com/brona/iproute2mac";
    description = "CLI wrapper for basic network utilites on Mac OS X inspired with iproute2 on Linux systems - ip command.";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    platforms = platforms.darwin;
  };
}
