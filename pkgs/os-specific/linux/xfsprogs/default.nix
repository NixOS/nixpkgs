{ stdenv, fetchurl, libtool, gettext, libuuid }:

stdenv.mkDerivation {
  name = "xfsprogs-2.9.7-1";

  src = fetchurl {
    urls = [ ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs_2.9.7-1.tar.gz http://ftp.lfs-matrix.org/pub/blfs/svn/x/xfsprogs_2.9.7-1.tar.gz ];
    sha256 = "0g4pr1rv4lgc7vab18wiwrcr6jq40fs1krb2vfkgh779p7gf3il7";
  };

  buildInputs = [libtool gettext libuuid];

  preConfigure =
    ''
      sp_path=$(echo $PATH | sed -e 's/:/ /g');
      sed -e 's@/usr/bin@'"$PATH: $sp_path"'@g' -i configure
      sed -e 's@/usr/local/bin@'"$PATH: sp_path"'@g' -i configure
    '';

  meta = {
    description = "SGI XFS utilities";
  };
}
