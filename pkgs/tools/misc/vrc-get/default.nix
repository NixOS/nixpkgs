{ fetchCrate, lib, rustPlatform, pkg-config, stdenv, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.8.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-j8B7g/w1Qtiuj099RlRLmrYTFiE7d2vVg/nTbaa8pRU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  cargoHash = "sha256-WFGY5osZIEYeHQchvuE3ddeqh2wzfZNV+SGqW08zYDI=";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
