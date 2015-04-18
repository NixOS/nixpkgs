{ stdenv, lib, bundlerEnv, ruby, curl }:

bundlerEnv {
  name = "fluentd-0.12.6";

  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  buildInputs = [ curl ];

  meta = with lib; {
    description = "Fluentd data collector.";
    homepage    = http://www.fluentd.org/;
    license     = with licenses; asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
