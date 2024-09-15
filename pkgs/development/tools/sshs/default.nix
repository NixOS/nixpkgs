{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  sshs,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshs";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = version;
    hash = "sha256-8tIIpGEQBXfLQ/Bok4KrpDGwoYhIQz/ylg6fUc6mBdc=";
  };

  cargoHash = "sha256-w+KYaYO3LXUEk4If6LSncS5KZJyNl8JMLGa+NtF3hf0=";

  passthru.tests.version = testers.testVersion { package = sshs; };

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
}
