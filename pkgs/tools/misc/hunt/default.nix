{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
    sha256 = "sha256-TwxNVT2x9Y0jnLXiIquf/bQ31B+2VwFfh9EFbJQHpt4=";
  };

  cargoHash = "sha256-GU3AXZJ8yGFnj0SXRezS/YI6aS/lJowwo+GBBv5wNik=";

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "hunt";
  };
}
