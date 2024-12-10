{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "chef-cli";
  gemdir = ./.;
  inherit ruby;

  exes = [ "chef-cli" ];

  passthru.updateScript = bundlerUpdateScript "chef-cli";

  meta = with lib; {
    description = "The Chef Infra Client is a powerful agent that applies your configurations on remote Linux, macOS, Windows and cloud-based systems";
    homepage = "https://chef.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    mainProgram = "chef-cli";
  };
}
