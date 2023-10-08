{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    rev = version;
    hash = "sha256-LbF/j6yKcH/OmrcYAvTN8L2XFYnULAAh9hCGsG/JkFg=";
  };

  cargoHash = "sha256-92sRJt6d96BoinXlw432Fyn2EjsuSUdOwyFtqj0iUXw=";

  meta = with lib; {
    description = "A formatter for the leptos view! macro";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
