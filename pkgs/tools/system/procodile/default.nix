{ lib, bundlerEnv, ruby, stdenv }:

bundlerEnv rec {
  name = "procodile-${version}";

  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  version = (import gemset).procodile.version;
  inherit ruby;

  gemdir = ./.;

  meta = with lib; {
    description = "Run processes in the background (and foreground) on Mac & Linux from a Procfile (for production and/or development environments)";
    homepage    = https://adam.ac/procodile;
    license     = with licenses; mit;
    maintainers = [ maintainers.ravloony ];
    platforms   = platforms.unix;
  };
}
