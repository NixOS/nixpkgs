{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "sha256-dtfOSj0WnNyQLimXkSK+L8pWL/oc0nIugDyUmGaBP3w=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoSha256 = "sha256-A9cL5veliWDNp1RbhOzR1e2X7c7mTAnl1qMATaMhhT8=";

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
