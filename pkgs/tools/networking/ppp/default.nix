a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2.4.4" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://ppp.samba.org/ftp/ppp/ppp-${version}.tar.gz";
    sha256 = "1sli1s478k85vmjdbrqm39nn5r20x9qgg3a0lbp2dwz50zy4bbsq";
  };

  inherit buildInputs;
  configureFlags = [];

  phaseNames = ["exportVars" "patchPrivileged" "doConfigure" "doMakeInstall"];

  exportVars = a.noDepEntry(''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -lcrypt "
  '');

  /* We want to run it as far as we can with our current permissions
     For example, dependent builds would prefer to run --version 
     without ever using setuid pppd. We are not setuid anyway, so.. */
  patchPrivileged = a.fullDepEntry(''
    sed -e '/privileged =/aprivileged = 1;' -i pppd/main.c
    sed -e '/SH DESCRIPTION/a WARNING: Patched version unsuitable to be setuid root' -i pppd/pppd.8
  '') ["minInit" "doUnpack"];

  passthru = {
    inherit version;
  };
      
  name = "ppp-" + version;
  meta = {
    description = "Point-to-point implementation for Linux and Solaris";
  };
}
