{ stdenv, fetchurl, readline, pam, openldap, popt, iniparser, libunwind, fam
, acl
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
  name = "samba-3.5.6";

  src = fetchurl {
    url = "http://us3.samba.org/samba/ftp/stable/${name}.tar.gz";
    sha256 = "1nj78bahph9fwxv0v3lz31cy6z167jgmvz63d8l9mlbmhf310r26";
  };

  buildInputs = [ readline pam openldap popt iniparser libunwind fam acl ]
    ++ stdenv.lib.optional useKerberos kerberos;

  preConfigure = "cd source3";

  configureFlags = ''
    --with-pam
    --with-cifsmount
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

  postInstall =
    ''
      mkdir -p $out
      mv $TMPDIR/inst/$out/* $out/
  
      mkdir -pv $out/lib/cups/backend
      ln -sv ../../../bin/smbspool $out/lib/cups/backend/smb
    '' # */
    + stdenv.lib.optionalString (configDir == "") "touch $out/lib/smb.conf";
}
