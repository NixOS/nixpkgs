{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "lazycli";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qq167hc7pp9l0m40ysphfljakmm8hjjnhpldvb0kbc825h0z8z5";
  };

  cargoSha256 = "sha256-1BIUXepR7ppEkTLDOCZz9RBv+RazNMXnCnH1rvzVFgs=";

  checkFlags = [
    # currently broken: https://github.com/jesseduffield/lazycli/pull/20
    "--skip=command::test_run_command_fail"
  ];

  meta = with lib; {
    description = "A tool to static turn CLI commands into TUIs";
    homepage = "https://github.com/jesseduffield/lazycli";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lazycli";
  };
}
