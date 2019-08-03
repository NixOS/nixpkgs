{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "fluentd";

  meta = with lib; {
    description = "A data collector";
    homepage    = https://www.fluentd.org/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
  };
}
