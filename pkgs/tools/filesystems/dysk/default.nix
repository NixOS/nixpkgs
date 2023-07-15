{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-rSnj38U4Rt5Wh+3A610tTeT2Q1BVGvpMa7rpDf4YzTI=";
  };

  cargoHash = "sha256-or1vLbtA2tPnGJ3tYWrmaXmPCIutojBlIWMLRNpxpY4=";

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda koral ];
  };
}
