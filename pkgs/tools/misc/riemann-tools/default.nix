{ stdenv, bundlerEnv }:

bundlerEnv {
  name = "riemann-tools-0.2.13";
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = {
    description = "Tools to submit data to Riemann";
    homepage = "https://riemann.io";
    license = stdenv.lib.licenses.mit;
  };
}
