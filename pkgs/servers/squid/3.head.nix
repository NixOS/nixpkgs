args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = [ "perl" ]; };
      # many options I don't know wether they should be default .. 
    }; 

    extraAttrs = co : {
      name = "squid-3.0-stable5";

      src = args.fetchurl {
        url = http://www.squid-cache.org/Versions/v3/HEAD/squid-3.HEAD-20080424.tar.bz2;
        sha256 = "0mqjq8112rjgn3nbpkg8iql32cnk5kiw8fmhj5gbqzbycbhaxjgz";
      };

      configureFlags = ["--enable-ipv6"];

      meta = { 
        description = "http-proxy";
        homepage = "http://www.squid-cache.org";
        license = "GPL2";
      };
  };
} ) args
