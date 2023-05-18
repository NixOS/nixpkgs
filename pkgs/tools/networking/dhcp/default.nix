{ stdenv, fetchurl, fetchpatch, perl, file, nettools, iputils, iproute2, makeWrapper
, coreutils, gnused, openldap ? null
, buildPackages, lib

# client and relay are end of life, remove after 4.4.3
, withClient ? false
, withRelay ? false
}:

stdenv.mkDerivation rec {
  pname = "dhcp";
  version = "4.4.3-P1";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/dhcp/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-CsQWu1WZfKhjIXT9EHN/1hzbjbonUhYKM1d1vCHcc8c=";
  };

  patches =
    [
      # Make sure that the hostname gets set on reboot.  Without this
      # patch, the hostname doesn't get set properly if the old
      # hostname (i.e. before reboot) is equal to the new hostname.
      ./set-hostname.patch
    ];

  nativeBuildInputs = [ perl makeWrapper ];

  buildInputs = [ openldap ];

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
  ] ++ lib.optional stdenv.isLinux "--with-randomdev=/dev/random"
    ++ lib.optionals (openldap != null) [ "--with-ldap" "--with-ldapcrypto" ]
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "BUILD_CC=$(CC_FOR_BUILD)";

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    "-Wno-error=pointer-compare"
    "-Wno-error=format-truncation"
    "-Wno-error=stringop-truncation"
    "-Wno-error=format-overflow"
    "-Wno-error=stringop-overflow=8"
  ];

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
        --replace /sbin/ip ${iproute2}/sbin/ip
      wrapProgram "$out/sbin/dhclient-script" --prefix PATH : \
        "${nettools}/bin:${nettools}/sbin:${iputils}/bin:${coreutils}/bin:${gnused}/bin"
    '' + lib.optionalString (!withClient) ''
      rm $out/sbin/{dhclient,dhclient-script,.dhclient-script-wrapped}
    '' + lib.optionalString (!withRelay) ''
      rm $out/sbin/dhcrelay
    '';

  preConfigure =
    ''
      substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
      sed -i "includes/dhcpd.h" \
          -e "s|^ *#define \+_PATH_DHCLIENT_SCRIPT.*$|#define _PATH_DHCLIENT_SCRIPT \"$out/sbin/dhclient-script\"|g"

      export AR='${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar'
    '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Dynamic Host Configuration Protocol (DHCP) tools";

    longDescription = ''
      ISC's Dynamic Host Configuration Protocol (DHCP) distribution
      provides a freely redistributable reference implementation of
      all aspects of DHCP, through a suite of DHCP tools: server,
      client, and relay agent.
   '';

    homepage = "https://www.isc.org/dhcp/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    knownVulnerabilities = lib.optional (withClient || withRelay) "The client and relay component of the dhcp package have reached their end of life";
  };
}
