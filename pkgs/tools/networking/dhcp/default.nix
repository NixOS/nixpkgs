{ stdenv, fetchurl, nettools, iputils, iproute, makeWrapper, coreutils, gnused }:

stdenv.mkDerivation rec {
  name = "dhcp-4.1-ESV-R6";
  
  src = fetchurl {
    url = http://ftp.isc.org/isc/dhcp/4.1-ESV-R6/dhcp-4.1-ESV-R6.tar.gz;
    sha256 = "17md1vml07szl9dx4875gfg4sgnb3z73glpbq1si7p82mfhnddny";
  };

  patches =
    [ # Don't bring down interfaces, because wpa_supplicant doesn't
      # recover when the wlan interface goes down.  Instead just flush
      # all addresses, routes and neighbours of the interface.
      ./flush-if.patch

      # Make sure that the hostname gets set on reboot.  Without this
      # patch, the hostname doesn't get set properly if the old
      # hostname (i.e. before reboot) is equal to the new hostname.
      ./set-hostname.patch
    ];

  # Fixes "socket.c:591: error: invalid application of 'sizeof' to
  # incomplete type 'struct in6_pktinfo'".  See
  # http://www.mail-archive.com/blfs-book@linuxfromscratch.org/msg13013.html
  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  # It would automatically add -Werror, which disables build in gcc 4.4
  # due to an uninitialized variable.
  CFLAGS = "-g -O2 -Wall";

  buildInputs = [ makeWrapper ];

  postInstall =
    ''
      cp client/scripts/linux $out/sbin/dhclient-script
      substituteInPlace $out/sbin/dhclient-script \
        --replace /sbin/ip ${iproute}/sbin/ip
      wrapProgram "$out/sbin/dhclient-script" --prefix PATH : \
        "${nettools}/bin:${nettools}/sbin:${iputils}/bin:${coreutils}/bin:${gnused}/bin"
    '';

  preConfigure =
    ''
      sed -i "includes/dhcpd.h" \
	-"es|^ *#define \+_PATH_DHCLIENT_SCRIPT.*$|#define _PATH_DHCLIENT_SCRIPT \"$out/sbin/dhclient-script\"|g"
    '';

  meta = {
    description = "Dynamic Host Configuration Protocol (DHCP) tools";

    longDescription = ''
      ISC's Dynamic Host Configuration Protocol (DHCP) distribution
      provides a freely redistributable reference implementation of
      all aspects of DHCP, through a suite of DHCP tools: server,
      client, and relay agent.
   '';

    homepage = http://www.isc.org/products/DHCP/;
    license = "http://www.isc.org/sw/dhcp/dhcp-copyright.php";
  };
}
