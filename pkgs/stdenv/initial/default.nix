# Here we construct an absolutely trivial `initial' standard
# environment.  It's not actually a functional stdenv, since there is
# not necessarily a working C compiler.  We need this to build
# gcc-wrapper et al. for the native stdenv.

{system, name}:

derivation {
  inherit system name;
  builder = ./builder.sh;
}