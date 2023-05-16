{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "hunt";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.7.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "LyonSyonII";
    repo = "hunt-rs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-TwxNVT2x9Y0jnLXiIquf/bQ31B+2VwFfh9EFbJQHpt4=";
  };

  cargoHash = "sha256-GU3AXZJ8yGFnj0SXRezS/YI6aS/lJowwo+GBBv5wNik=";
=======
    sha256 = "sha256-mNQY2vp4wNDhVqrFNVS/RBXVi9EMbTZ6pE0Z79dLUeM=";
  };

  cargoSha256 = "sha256-hjvJ9E5U6zGSWUXNDdu0GwUcd7uZeconfjiCSaEzZXU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Simplified Find command made with Rust";
    homepage = "https://github.com/LyonSyonII/hunt";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
