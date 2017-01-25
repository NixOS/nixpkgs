{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  inherit ruby;
  pname = "fpm";
  gemdir = ./.;

  meta = with lib; {
    description = "Tool to build packages for multiple platforms with ease";
    homepage    = https://github.com/jordansissel/fpm;
    license     = licenses.mit;
    platforms   = platforms.unix;
  };
}
