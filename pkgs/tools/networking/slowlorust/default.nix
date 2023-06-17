{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "slowlorust";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MJVL";
    repo = pname;
    rev = version;
    sha256 = "c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoSha256 = "Wu1mm+yJw2SddddxC5NfnMWLr+dplnRxH3AJ1/mTAKM=";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Lightweight slowloris (HTTP DoS) tool";
    homepage = "https://github.com/MJVL/slowlorust";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
