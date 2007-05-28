{ stdenv
, fetchurl
, pie ? false
, socketWrapper ? false
, cups ? false
, iprint ? false
, activeDirectory ? false
, stateDir ? "/tmp/sambastate/"                   # (builtins.getEnv "HOME") + "/sambastate/"
} :

stdenv.mkDerivation {
  name = "samba-3.0.24";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.bit.nl/mirror/samba/old-versions/samba-3.0.24.tar.gz;		#TODO, change this to a URL of cs.uu.nl/...
    md5 = "89273F67A6D8067CBBECEFAA13747153";
  };

  smbconf = ./smb.conf;
  inherit stateDir;
}
