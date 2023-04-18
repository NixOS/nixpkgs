{ lib, ruby, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "cinc-auditor-bin";
  gemdir = ./.;

  inherit ruby;

  exes = ["cinc-auditor"];

  passthru.updateScript = bundlerUpdateScript "cinc-auditor-bin";

  meta = with lib; {
    description = "Cinc Auditor is the community build of Inspec, an open-source testing framework for infrastructure";
    homepage = "https://cinc.sh/start/auditor/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    platforms = platforms.unix;
  };
}
