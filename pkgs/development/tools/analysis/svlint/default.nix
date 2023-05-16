{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
<<<<<<< HEAD
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bd0epx3AciECCYi4OYG2WzTVhZ+JYnf5ebDZoMrPfmo=";
  };

  cargoHash = "sha256-RjjYfdcdJzIxnJFZqx93KADihN5YK+bCuk1QaPhVuGQ=";
=======
  version = "0.7.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-yo0SgNnwy0LnbIOCLwHUpzjgTZzOoO5GHzKmNVFQOtE=";
  };

  cargoHash = "sha256-3ELBEalMQE+Ozgud+RECl5ClBLy3TqGaEry2OwZ2pGk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cargoBuildFlags = [ "--bin" "svlint" ];

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
