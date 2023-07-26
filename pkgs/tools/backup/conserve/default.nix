{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "conserve";
  version = "23.5.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${version}";
    hash = "sha256-OzSTueaw2kWc2e45zckXS2O4bfykREOcz8/PpUIK09w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nutmeg-0.1.3-pre" = "sha256-WcbQf8DZ9ryY+TWcVObdHj005GvfeMG+wesr6FiCUCE=";
    };
  };

  meta = with lib; {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
