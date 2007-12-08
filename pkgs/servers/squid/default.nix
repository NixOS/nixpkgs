args:
( args.mkDerivationByConfiguration {
    flagConfig = {
      mandatory = { buildInputs = [ "perl" ]; };
      # many options I don't know wether they should be default .. 
    }; 

    extraAttrs = co : {
      name = "squid-2.6-stable";

      src = args.fetchurl {
        url = http://www.squid-cache.org/Versions/v2/2.6/squid-2.6.STABLE16.tar.bz2;
        sha256 = "1iv21a4cl74bqzrk07l0lbzlq3n9qpd0r31fgsjv2dsabj46qc4y";
      };

      meta = { 
        description = "http-proxy";
        homepage = "http://www.squid-cache.org";
        license = "GPL2";
      };
  };
} ) args
