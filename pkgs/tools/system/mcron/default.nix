{ fetchurl, lib, stdenv, guile, which, ed, libtool }:

stdenv.mkDerivation rec {
  pname = "mcron";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://gnu/mcron/mcron-${version}.tar.gz";
    sha256 = "0yvrfzzdy2m7fbqkr61fw01wd9r2jpnbyabxhcsfivgxywknl0fy";
  };

  patches = [ ./install-vixie-programs.patch ];

  # don't attempt to chmod +s files in the nix store
  postPatch = ''
    substituteInPlace makefile.in --replace "rwxs" "rwx"
  '';

  buildInputs = [ guile which ed libtool ];

  doCheck = true;

  meta = {
    description = "Flexible implementation of `cron' in Guile";

    longDescription = ''
      The GNU package mcron (Mellor's cron) is a 100% compatible
      replacement for Vixie cron.  It is written in pure Guile, and
      allows configuration files to be written in scheme (as well as
      Vixie's original format) for infinite flexibility in specifying
      when jobs should be run.  Mcron was written by Dale Mellor.
    '';

    homepage = "https://www.gnu.org/software/mcron/";

    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
