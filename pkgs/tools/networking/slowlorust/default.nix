{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "slowlorust";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MJVL";
    repo = pname;
    rev = version;
    hash = "sha256-c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoHash = "sha256-Wu1mm+yJw2SddddxC5NfnMWLr+dplnRxH3AJ1/mTAKM=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Lightweight slowloris (HTTP DoS) tool";
    homepage = "https://github.com/MJVL/slowlorust";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "slowlorust";
  };
}
