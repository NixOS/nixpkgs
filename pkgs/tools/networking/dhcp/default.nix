{ stdenv, fetchurl, perl, file, nettools, iputils, iproute, makeWrapper
, coreutils, gnused, openldap ? null
, buildPackages, lib
}:

stdenv.mkDerivation rec {
  name = "dhcp-${version}";
  version = "4.4.1";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/dhcp/${version}/${name}.tar.gz";
    sha256 = "025nfqx4zwdgv4b3rkw26ihcj312vir08jk6yi57ndmb4a4m08ia";
  };

  patches =
    [
      # Make sure that the hostname gets set on reboot.  Without this
      # patch, the hostname doesn't get set properly if the old
      # hostname (i.e. before reboot) is equal to the new hostname.
      ./set-hostname.patch
    ];

  nativeBuildInputs = [ perl ];

  buildInputs = [ makeWrapper openldap ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

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
    (lib.optional stdenv.isLinux "--with-randomdev=/dev/random")
  ] ++ stdenv.lib.optionals (openldap != null) [ "--with-ldap" "--with-ldapcrypto" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=pointer-compare" ];

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

      export AR='${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar'
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
  };
}
