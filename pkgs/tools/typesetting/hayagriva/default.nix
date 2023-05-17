{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "hayagriva";
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zp7YfMmp16YRWNcOf5aVt1vXnL+23+DyFeFn7Gow7wM=";
  };

  cargoHash = "sha256-jsVd4vyST563HiXvqCfiZ2oUhNXF4E8Y2HBLl5AtvRw=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Work with references: Literature database management, storage, and citation formatting";
    homepage = "https://github.com/typst/hayagriva";
    changelog = "https://github.com/typst/hayagriva/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
