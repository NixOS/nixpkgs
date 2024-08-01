{ lib, bundlerEnv, ruby, bundlerUpdateScript, nixosTests }:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "fluentd";
  passthru.tests.fluentd = nixosTests.fluentd;

  meta = with lib; {
    description = "Data collector";
    homepage    = "https://www.fluentd.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline nicknovitski ];
    platforms   = platforms.unix;
  };
}
