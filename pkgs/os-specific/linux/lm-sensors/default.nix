{ stdenv, fetchzip, bison, flex, which, perl
, sensord ? false, rrdtool ? null
}:

assert sensord -> rrdtool != null;

stdenv.mkDerivation rec {
  pname = "lm-sensors";
  version = "3.6.0";

  src = fetchzip {
    url = "https://github.com/lm-sensors/lm-sensors/archive/V${stdenv.lib.replaceStrings ["."] ["-"] version}.tar.gz";
    sha256 = "1ipf6wjx037sqyhy0r5jh4983h216anq9l68ckn2x5c3qc4wfmzn";
  };

  nativeBuildInputs = [ bison flex which ];
  buildInputs = [ perl ]
   ++ stdenv.lib.optional sensord rrdtool;

  preBuild = ''
    makeFlagsArray=(PREFIX=$out ETCDIR=$out/etc
    ${stdenv.lib.optionalString sensord "PROG_EXTRA=sensord"})
  '';

  meta = with stdenv.lib; {
    homepage = https://hwmon.wiki.kernel.org/lm_sensors;
    description = "Tools for reading hardware sensors";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
  };
}
