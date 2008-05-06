args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = [ "perl" ]; };
      # many options I don't know wether they should be default .. 
    }; 

    extraAttrs = co : {
      name = "squid-3.0-stable5";

      src = args.fetchurl {
        url = http://www.squid-cache.org/Versions/v3/3.0/squid-3.0.STABLE5.tar.bz2;
        sha256 = "1m4ccpjw30q9vwsycmgg9dmhly0mpznvxrch6f7dxgfzpjp26l7w";
      };

      configureFlags = ["--enable-ipv6"];

      meta = { 
        description = "http-proxy";
        homepage = "http://www.squid-cache.org";
        license = "GPL2";
      };
  };
} ) args
