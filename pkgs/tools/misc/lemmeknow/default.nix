{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lemmeknow";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-rSuHFVUYpL1v5ba0q15mNEuAHzFF9tWxFs3zTJt5zcc=";
  };

  cargoSha256 = "sha256-x//spFPlmJJAIyI5RgnYlMORi4eCXc8p7iEJQ7Ayptw=";

  meta = with lib; {
    description = "A tool to identify anything";
    homepage = "https://github.com/swanandx/lemmeknow";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda Br1ght0ne ];
  };
}
