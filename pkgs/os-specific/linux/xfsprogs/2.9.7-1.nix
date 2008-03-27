args : with args; 
rec {
  src = fetchurl {
    url = ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.9.7-1.tar.gz;
    sha256 = "0g4pr1rv4lgc7vab18wiwrcr6jq40fs1krb2vfkgh779p7gf3il7";
  };

  buildInputs = [libtool gettext e2fsprogs];
  configureFlags = [];

  preConfigure = FullDepEntry (''
    sp_path=$(echo $PATH | sed -e 's/:/ /g');
    sed -e 's@/usr/bin@'"$PATH: $sp_path"'@g' -i configure
    sed -e 's@/usr/local/bin@'"$PATH: sp_path"'@g' -i configure
  '') ["minInit" "doUnpack" "addInputs"];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];
      
  name = "xfsprogs-" + version;
  meta = {
    description = "SGI XFS utilities";
  };
}
  
