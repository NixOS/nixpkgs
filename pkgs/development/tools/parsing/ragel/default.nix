{ stdenv, fetchurl, transfig, tex, ghostscript, colm
, build-manual ? false
}:

let
  generic = { version, sha256, license }:
    stdenv.mkDerivation rec {
      name = "ragel-${version}";

      src = fetchurl {
        url = "http://www.colm.net/files/ragel/${name}.tar.gz";
        inherit sha256;
      };

      buildInputs = stdenv.lib.optional build-manual [ transfig ghostscript tex ];

      preConfigure = stdenv.lib.optional build-manual ''
        sed -i "s/build_manual=no/build_manual=yes/g" DIST
      '';

      configureFlags = [ "--with-colm=${colm}" ];

      NIX_CFLAGS_COMPILE = "-std=gnu++98";

      doCheck = true;

      meta = with stdenv.lib; {
        homepage = http://www.complang.org/ragel;
        description = "State machine compiler";
        inherit license;
        platforms = platforms.unix;
        maintainers = with maintainers; [ pSub ];
      };
    };

in

{
  ragelStable = generic {
    version = "6.10";
    sha256 = "0gvcsl62gh6sg73nwaxav4a5ja23zcnyxncdcdnqa2yjcpdnw5az";
    license = stdenv.lib.licenses.gpl2;
  };

  ragelDev = generic {
    version = "7.0.0.10";
    sha256 = "1v4ddzxal4gf8l8nkn32qabba6nbpd2mg8sphgmdn8kaqv52nmj0";
    license = stdenv.lib.licenses.mit;
  };
}
