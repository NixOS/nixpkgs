{ callPackage }:

rec {
  audio = callPackage ../development/pure-modules/audio { };
  avahi = callPackage ../development/pure-modules/avahi { };
  csv = callPackage ../development/pure-modules/csv { };
  doc = callPackage ../development/pure-modules/doc { };
  fastcgi = callPackage ../development/pure-modules/fastcgi { };
  faust = callPackage ../development/pure-modules/faust { };
  ffi = callPackage ../development/pure-modules/ffi { };
  gen = callPackage ../development/pure-modules/gen { };
  gl = callPackage ../development/pure-modules/gl { };
  glpk = callPackage ../development/pure-modules/glpk { };
  gplot = callPackage ../development/pure-modules/gplot { };
  gsl = callPackage ../development/pure-modules/gsl { };
  gtk = callPackage ../development/pure-modules/gtk { pure-ffi = ffi; };
  liblo = callPackage ../development/pure-modules/liblo { };
  lilv = callPackage ../development/pure-modules/lilv { };
  lv2 = callPackage ../development/pure-modules/lv2 { };
  midi = callPackage ../development/pure-modules/midi { };
  mpfr = callPackage ../development/pure-modules/mpfr { };
  octave = callPackage ../development/pure-modules/octave { };
  odbc = callPackage ../development/pure-modules/odbc { };
  pandoc = callPackage ../development/pure-modules/pandoc { };
  rational = callPackage ../development/pure-modules/rational { };
  readline = callPackage ../development/pure-modules/readline { };
  sockets = callPackage ../development/pure-modules/sockets { };
  sql3 = callPackage ../development/pure-modules/sql3 { };
  stldict = callPackage ../development/pure-modules/stldict { };
  stllib = callPackage ../development/pure-modules/stllib { };
  tk = callPackage ../development/pure-modules/tk { };
  xml = callPackage ../development/pure-modules/xml { };
}
