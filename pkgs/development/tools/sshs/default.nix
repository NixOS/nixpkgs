{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  sshs,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshs";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = "sshs";
    rev = version;
    hash = "sha256-07iivB9U0rFnoohjBX7EfdoDq4VDMALWy4CWiSrrg58=";
  };

  cargoHash = "sha256-W6PuwDcb2VAGX7bfeZtr/xNuLRTUCUgTc/KvvUinv7k=";

  passthru.tests.version = testers.testVersion { package = sshs; };

  meta = {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
}
