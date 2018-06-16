{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "sqlint-${version}";
  version = (import ./gemset.nix).sqlint.version;

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "Simple SQL linter";
    homepage    = https://github.com/purcell/sqlint;
    license     = licenses.mit;
    platforms   = ruby.meta.platforms;
  };
}
