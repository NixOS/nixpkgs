{stdenv, getopt, src}:

derivation {
  name = "strategoxt-test-build";
  system = stdenv.system;

  builder = ./strategoxt-test-build.sh;
  src = src;

  stdenv = stdenv;
  getopt = getopt; # required by sdf2table
}
