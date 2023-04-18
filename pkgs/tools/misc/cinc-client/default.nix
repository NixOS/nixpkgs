{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "chef-bin";
  gemdir = ./.;

  inherit ruby;

  exes = ["cinc-client"];

  passthru.updateScript = bundlerUpdateScript "chef-bin";

  meta = with lib; {
    description = "Cinc Client is the community build of the Chef infra client";
    homepage = "https://cinc.sh/start/client/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
  };
}
