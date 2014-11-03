{ stdenv, fetchurl, perl, file, nettools, iputils, iproute, makeWrapper, coreutils, gnused }:

stdenv.mkDerivation rec {
  name = "dhcp-${version}";
  version = "4.3.0";
  
  src = fetchurl {
    url = "http://ftp.isc.org/isc/dhcp/${version}/${name}.tar.gz";
    sha256 = "12mydvj6x3zcl3gla06bywfkkrgg03g66fijs94mwb7kbiym3dm7";
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
  #
  # Also adds the ability to run dhcpd as a non-root user / group
  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE -DPARANOIA";

  # It would automatically add -Werror, which disables build in gcc 4.4
  # due to an uninitialized variable.
  CFLAGS = "-g -O2 -Wall";

  buildInputs = [ perl makeWrapper ];

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
      substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
      sed -i "includes/dhcpd.h" \
	-"es|^ *#define \+_PATH_DHCLIENT_SCRIPT.*$|#define _PATH_DHCLIENT_SCRIPT \"$out/sbin/dhclient-script\"|g"
    '';

  meta = with stdenv.lib; {
    description = "Dynamic Host Configuration Protocol (DHCP) tools";

    longDescription = ''
      ISC's Dynamic Host Configuration Protocol (DHCP) distribution
      provides a freely redistributable reference implementation of
      all aspects of DHCP, through a suite of DHCP tools: server,
      client, and relay agent.
   '';

    homepage = http://www.isc.org/products/DHCP/;
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
