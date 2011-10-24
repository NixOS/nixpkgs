{ stdenv, fetchurl, readline, pam, openldap, popt, iniparser, libunwind, fam
, acl, cups
, useKerberos ? false, kerberos ? null, winbind ? true

# Eg. smbclient and smbspool require a smb.conf file.
# If you set configDir to "" an empty configuration file
# $out/lib/smb.conf is is created for you.
#
# configDir defaults to "/etc/samba" so that smbpassword picks up
# the location of its passwd db files from the system configuration file
# /etc/samba/smb.conf. That's why nixos touches /etc/samba/smb.conf even if you
# don't enable the samba upstart service.
, configDir ? "/etc/samba"

}:

let

 useWith = flag: option: if flag then "--with-"+option else "";
 
in

stdenv.mkDerivation rec {
  name = "samba-3.6.1";

  src = fetchurl {
    url = "http://us3.samba.org/samba/ftp/stable/${name}.tar.gz";
    sha256 = "0r6mbghja357xhpada5djg0gpczi50f18ap53hdn8b7y0amz5c65";
  };

  patches =
    [ # Fix for https://bugzilla.samba.org/show_bug.cgi?id=8541.
      ./readlink.patch
    ];

  buildInputs = [ readline pam openldap popt iniparser libunwind fam acl cups ]
    ++ stdenv.lib.optional useKerberos kerberos;

  enableParallelBuilding = true;

  preConfigure = "cd source3";

  configureFlags = ''
    --with-pam
    --with-aio-support
    --with-pam_smbpass
    --disable-swat
    --with-configdir=${configDir}
    --with-fhs
    --localstatedir=/var
    ${useWith winbind "winbind"}
    ${if stdenv.gcc.libc != null then "--with-libiconv=${stdenv.gcc.libc}" else ""}
  '';

  # Need to use a DESTDIR because `make install' tries to write in /var and /etc.
  installFlags = "DESTDIR=$(TMPDIR)/inst";

  stripAllList = [ "bin" "sbin" ];

  postInstall =
    ''
      mkdir -p $out
      mv $TMPDIR/inst/$out/* $out/
  
      mkdir -pv $out/lib/cups/backend
      ln -sv ../../../bin/smbspool $out/lib/cups/backend/smb
      mkdir -pv $out/etc/openldap/schema
      cp ../examples/LDAP/samba.schema $out/etc/openldap/schema
    '' # */
    + stdenv.lib.optionalString (configDir == "") "touch $out/lib/smb.conf";
}
