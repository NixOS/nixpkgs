{ fetchurl, stdenv, guile, which, ed }:

stdenv.mkDerivation rec {
  name = "mcron-1.0.4";

  src = fetchurl {
    url = "mirror://gnu/mcron/${name}.tar.gz";
    sha256 = "0wrpi9qj50a8wfslapnkmsr6d3qx40hfw57a022m1z1syiljq4xl";
  };

  patches = [ ./install-vixie-programs.patch ];

  buildInputs = [ guile which ed ];

  meta = {
    description = "GNU mcron, a flexible implementation of `cron' in Guile";

    longDescription = ''
      The GNU package mcron (Mellor's cron) is a 100% compatible
      replacement for Vixie cron.  It is written in pure Guile, and
      allows configuration files to be written in scheme (as well as
      Vixie's original format) for infinite flexibility in specifying
      when jobs should be run.  Mcron was written by Dale Mellor.
    '';

    homepage = http://www.gnu.org/software/mcron/;

    license = "GPLv3+";
  };
}
