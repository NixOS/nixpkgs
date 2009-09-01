a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    openssl gmp
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [
    "--enable-tcp"
    "--enable-http-proxy"
    "--enable-dns"
    ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A proteted multinode virtual network";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; linux ++ freebsd;
  };
}
