a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    bison flex openssl
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];
  configureFlags = [
    "--with-ssl-incl-dir=${a.openssl}/include"
    "--with-ssl-lib-dir=${a.openssl}/lib"
    ];
  preConfigure = a.fullDepEntry (''
    sed -e 's@/bin/@@' -i Makefile.in
  '') ["doUnpack" "minInit"];
      
  meta = {
    description = "Monitoring system";
    maintainers = [
      a.lib.maintainers.raskin
    ];
  };
}
