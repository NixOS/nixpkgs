{ lib, fetchFromGitHub, rustPlatform, gitUpdater, testers, fsrx }:

rustPlatform.buildRustPackage rec {
  pname = "fsrx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "coloradocolby";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pKdxYO8Rhck3UYxqiWHDlrlPS4cAPe5jLUu5Dajop/k=";
  };

  cargoSha256 = "sha256-5h+ou9FLCG/WWMEQPsCTa1q+PovxUJs+6lzQ0L2bKIs=";

  passthru = {
    updateScript = gitUpdater {
      inherit pname version;
      rev-prefix = "v";
    };
    tests.version = testers.testVersion {
      package = fsrx;
    };
  };

  meta = with lib; {
    description = "A flow state reader in the terminal";
    homepage = "https://github.com/coloradocolby/fsrx";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
