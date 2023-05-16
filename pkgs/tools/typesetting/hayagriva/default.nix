{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
<<<<<<< HEAD
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4HX0X8HDn0/D9mcruCVKeIs9ryCxYagW5eJ/DSqtprY=";
  };

  cargoHash = "sha256-JvRWdoZ5/jG09ex7avkE3JUcdMGIsfirSx9PDyAtVfU=";
=======
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zp7YfMmp16YRWNcOf5aVt1vXnL+23+DyFeFn7Gow7wM=";
  };

  cargoHash = "sha256-jsVd4vyST563HiXvqCfiZ2oUhNXF4E8Y2HBLl5AtvRw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
