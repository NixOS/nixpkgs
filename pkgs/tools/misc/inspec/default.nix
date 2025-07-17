{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "inspec";
  gemdir = ./.;

  inherit ruby;

  exes = [ "inspec" ];

  passthru.updateScript = bundlerUpdateScript "inspec";

  meta = with lib; {
    description = "Inspec is an open-source testing framework for infrastructure with a human- and machine-readable language for specifying compliance, security and policy requirements";
    homepage = "https://inspec.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    mainProgram = "inspec";
  };
}
