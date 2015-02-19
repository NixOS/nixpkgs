{ stdenv, binutils_raw }:

stdenv.mkDerivation {
  name = "sw_vers";
  buildCommand = ''
    mkdir -p $out/bin
    cat >$out/bin/sw_vers <<EOF
    #!${stdenv.shell}
    if test "\$#" -eq 0 ;
    then 
      echo "ProductName:    Mac OS X"
      echo "ProductVersion: 10.7.5"
      echo "BuildVersion:   11G63"
    elif [ "\$1" = "-productName" ];
    then
        echo "Mac OS X"
    elif [ "\$1" = "-productVersion" ];
    then
        echo "10.7.5"
    elif [ "\$1" = "-buildVersion" ];
    then
        echo "11G63"
    fi
    EOF
    chmod a+x $out/bin/sw_vers
  '';
}