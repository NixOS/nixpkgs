a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    openssl zlib pcre libxml2 libxslt
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_gzip_static_module"
    "--with-http_secure_link_module"
    # Install destination problems
    # "--with-http_perl_module" 
  ];

  preConfigure = a.fullDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.libxml2}/include/libxml2"
  '' [];

  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];
      
  meta = {
    description = "nginx - 'engine x' - reverse proxy and lightweight webserver";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      all;
  };
}
