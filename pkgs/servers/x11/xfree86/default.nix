{ buildServer ? true
, buildClientLibs ? true
, stdenv, fetchurl, bison, flex}:

assert !buildServer; # we don't support this currently
assert buildClientLibs; # we don't support *not* doing this currently
assert bison != null && flex != null;

derivation {
  name = "xfree86-4.3";
  system = stdenv.system;

  builder = ./builder.sh;
  hostdef = ./host.def;
  src1 = fetchurl {
    url = ftp://gnu.kookel.org/pub/XFree86/4.3.0/source/X430src-1.tgz;
    md5 = "4f241a4f867363f40efa2b00dca292af";
  };
  src2 = fetchurl {
    url = ftp://gnu.kookel.org/pub/XFree86/4.3.0/source/X430src-2.tgz;
    md5 = "844c2ee908d21dbf8911fd13115bf8b4";
  };
  src3 = fetchurl {
    url = ftp://gnu.kookel.org/pub/XFree86/4.3.0/source/X430src-3.tgz;
    md5 = "b82a0443e1b7bf860e4343e6b6766cb6";
  };

  buildServer = buildServer;
  buildClientLibs = buildClientLibs;

  stdenv = stdenv;
  bison = bison;
  flex = flex;
}
