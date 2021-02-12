{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "rebazel";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "meetup";
    repo = "rebazel";
    rev = "v${version}";
    hash = "sha256-v84ZXhtJpejQmP61NmP06+qrtMu/0yb7UyD7U12xlME=";
  };

  cargoSha256 = "sha256-Da/xQgSUOdMr6rH3RVDz7bCMaeBSCLlfKHvf+JBkabc=";

  meta = with lib; {
    description = "tool for expediting bazel build workflows";
    homepage = "https://github.com/meetup/rebazel";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
