{ stdenv, fetchurl, perl, file, nettools, iputils, iproute, makeWrapper
, coreutils, gnused, openldap ? null
}:

stdenv.mkDerivation rec {
  name = "dhcp-${version}";
  version = "4.3.4";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/dhcp/${version}/${name}.tar.gz";
    sha256 = "0zk0imll6bfyp9p4ndn8h6s4ifijnw5bhixswifr5rnk7pp5l4gm";
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

  buildInputs = [ perl makeWrapper openldap ];

  configureFlags = [
    "--enable-failover"
    "--enable-execute"
    "--enable-tracing"
    "--enable-delayed-ack"
    "--enable-dhcpv6"
    "--enable-paranoia"
    "--enable-early-chroot"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ] ++ stdenv.lib.optionals (openldap != null) [ "--with-ldap" "--with-ldapcrypto" ];

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall =
    ''
      mv $out/$out/* $out
      DIR=$out/$out
      while rmdir $DIR 2>/dev/null; do
        DIR="$(dirname "$DIR")"
      done

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
