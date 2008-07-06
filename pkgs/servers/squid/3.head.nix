args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = [ "perl" ]; };
      # many options I don't know wether they should be default .. 
    }; 

    extraAttrs = co : {
      name = "squid-3.0-stable5";

      src = args.fetchurl {
	url = http://www.squid-cache.org/Versions/v3/HEAD/squid-3.HEAD-20080706.tar.bz2;
        sha256 = "20f5994dd2189faa07edaef2c529f385e4590266d283745027b35d140eefe1ab";
      };

      configureFlags = ["--enable-ipv6"];

      meta = { 
        description = "http-proxy";
        homepage = "http://www.squid-cache.org";
        license = "GPL2";
      };
  };
} ) args
