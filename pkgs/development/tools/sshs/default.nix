{ lib
, rustPlatform
, fetchFromGitHub
, testers
, sshs
}:

rustPlatform.buildRustPackage rec {
  pname = "sshs";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = pname;
    rev = version;
    hash = "sha256-aUn2O3yToSEJVLpVcYGsKaWrDR/iTDX9BMBCBKXyx0I=";
  };

  cargoLock = {
    # Patch version output
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -sf ${./Cargo.toml} Cargo.toml
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  passthru.tests.version = testers.testVersion {
    package = sshs;
  };

  meta = with lib; {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = licenses.mit;
    maintainers = with maintainers; [ not-my-segfault ];
    mainProgram = "sshs";
  };
}
