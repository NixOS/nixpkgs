{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
<<<<<<< HEAD
, Security
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "slowlorust";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MJVL";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoHash = "sha256-Wu1mm+yJw2SddddxC5NfnMWLr+dplnRxH3AJ1/mTAKM=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
=======
    sha256 = "c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoSha256 = "Wu1mm+yJw2SddddxC5NfnMWLr+dplnRxH3AJ1/mTAKM=";

  meta = with lib; {
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Lightweight slowloris (HTTP DoS) tool";
    homepage = "https://github.com/MJVL/slowlorust";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
