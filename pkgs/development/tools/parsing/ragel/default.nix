{ stdenv, fetchurl, transfig, tex, ghostscript, colm
, build-manual ? false
}:

let
  generic = { version, sha256 }:
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

      doCheck = true;

      meta = with stdenv.lib; {
        homepage = http://www.complang.org/ragel;
        description = "State machine compiler";
        license = licenses.gpl2;
        platforms = platforms.unix;
        maintainers = with maintainers; [ pSub ];
      };
    };

in

{
  ragelStable = generic {
    version = "6.9";
    sha256 = "02k6rwh8cr95f1p5sjjr3wa6dilg06572xz1v71dk8awmc7vw1vf";
  };

  ragelDev = generic {
    version = "7.0.0.9";
    sha256 = "1w2jhfg3fxl15gcmm7z3jbi6splgc83mmwcfbp08lfc8sg2wmrmr";
  };
}
