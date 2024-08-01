{ lib, fetchFromGitHub, rustPlatform, testers, fsrx }:

rustPlatform.buildRustPackage rec {
  pname = "fsrx";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "thatvegandev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hzfpjunP20WCt3erYu7AO7A3nz+UMKdFzWUA5jASbVA=";
  };

  cargoHash = "sha256-bRStmz2sJnhCKpvoQfc/ZP9B2ZdNHYNEHd+wZErdS1Y=";

  passthru = {
    tests.version = testers.testVersion {
      package = fsrx;
    };
  };

  meta = with lib; {
    description = "Flow state reader in the terminal";
    homepage = "https://github.com/thatvegandev/fsrx";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
    mainProgram = "fsrx";
  };
}
