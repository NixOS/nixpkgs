{ lib, bundlerEnv, ruby }:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  meta = with lib; {
    description = "A data collector";
    homepage    = https://www.fluentd.org/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
