{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
<<<<<<< HEAD
  version = "0.1.62";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZewsR6MgBf8wdqBIrYAuprmqthhbEA/WDShp9H3jfDs=";
  };

  cargoHash = "sha256-UHUNoI9QqHzgYIuKlj0giWfFgS+F3eUC/wuAXgwH2xQ=";
=======
  version = "0.1.59";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-96KfjxpFw1uNejN917KMX98zxzJmozMiS99Aex2w4tM=";
  };

  cargoHash = "sha256-t4MuazMC8VJLj2SwY/crkd2W/ioRkdjvL5ZWiCp+7tE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
