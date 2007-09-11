{ stdenv
, fetchurl
, pie ? false
, socketWrapper ? false
, cups ? false
, iprint ? false
, activeDirectory ? false
, stateDir ? "/var/samba"                   # (builtins.getEnv "HOME") + "/sambastate/"
} :

stdenv.mkDerivation {
  name = "samba-3.0.25b";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://us1.samba.org/samba/ftp/stable/samba-3.0.25b.tar.gz;
    sha256 = "18l71skn7mryg78jpd8x38pf27wvrx00v33w3z2ycsfnrbcp8l6w";
  };

  smbconf = ./smb.conf;
  inherit stateDir;
}
