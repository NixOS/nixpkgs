args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  FullDepEntry = args.FullDepEntry;

  version = lib.getAttr ["version"] "0.7.23" args; 
  buildInputs = with args; [
    openssl zlib pcre libxml2 libxslt
  ];
in
rec {
  src = fetchurl {
    url = "http://sysoev.ru/nginx/nginx-${version}.tar.gz";
    sha256 = "1fygkagzclfqygipgi140jf3aiwqn8yqxjmk181i31p4di5m46rk";
  };

  inherit buildInputs;
  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_gzip_static_module"
    "--with-http_secure_link_module"
  ];

  preConfigure = FullDepEntry ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${args.libxml2}/include/libxml2"
  '' [];

  /* doConfigure should be specified separately */
  phaseNames = ["preConfigure" "doConfigure" "doMakeInstall"];
      
  name = "nginx-" + version;
  meta = {
    description = "nginx - 'engine x' - reverse proxy and lightweight webserver";
  };
}
