{ stdenv, fetchzip, bison, flex, which, perl
, sensord ? false, rrdtool ? null
}:

assert sensord -> rrdtool != null;

stdenv.mkDerivation rec {
  pname = "lm-sensors";
  version = "3.6.0";
  dashedVersion = stdenv.lib.replaceStrings ["."] ["-"] version;

  src = fetchzip {
    url = "https://github.com/lm-sensors/lm-sensors/archive/V${dashedVersion}.tar.gz";
    sha256 = "1ipf6wjx037sqyhy0r5jh4983h216anq9l68ckn2x5c3qc4wfmzn";
  };

  nativeBuildInputs = [ bison flex which ];
  buildInputs = [ perl ]
   ++ stdenv.lib.optional sensord rrdtool;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ] ++ stdenv.lib.optional sensord "PROG_EXTRA=sensord";

  meta = with stdenv.lib; {
    homepage = "https://hwmon.wiki.kernel.org/lm_sensors";
    changelog = "https://raw.githubusercontent.com/lm-sensors/lm-sensors/V${dashedVersion}/CHANGES";
    description = "Tools for reading hardware sensors";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    platforms = platforms.linux;
  };
}
