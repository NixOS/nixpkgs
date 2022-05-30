{ lib, stdenv, fetchurl, fig2dev, tex, ghostscript, colm
, build-manual ? false
}:

let
  generic = { version, sha256, license }:
    stdenv.mkDerivation rec {
      pname = "ragel";
      inherit version;

      src = fetchurl {
        url = "https://www.colm.net/files/ragel/${pname}-${version}.tar.gz";
        inherit sha256;
      };

      buildInputs = lib.optional build-manual [ fig2dev ghostscript tex ];

      preConfigure = lib.optionalString build-manual ''
        sed -i "s/build_manual=no/build_manual=yes/g" DIST
      '';

      configureFlags = [ "--with-colm=${colm}" ];

      NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=gnu++98";

      doCheck = true;

      meta = with lib; {
        broken = stdenv.isDarwin;
        homepage = "https://www.colm.net/open-source/ragel/";
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
    license = lib.licenses.gpl2;
  };

  ragelDev = generic {
    version = "7.0.0.12";
    sha256 = "0x3si355lv6q051lgpg8bpclpiq5brpri5lv3p8kk2qhzfbyz69r";
    license = lib.licenses.mit;
  };
}
