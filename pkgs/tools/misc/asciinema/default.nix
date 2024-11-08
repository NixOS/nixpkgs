{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "asciinema";
  version = "3.0.0-rc.3";
  pyproject = true;

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BUVD+kdQBzIM0gbj8jNKjWoJIHJFPrwi36m1eefPZJM=";
  };

  cargoHash = "sha256-CYDy0CedwG/ThTV+XOfOg8ncxF3tdTEGakmu4MXfiE4=";

  doCheck = false; # TEMP until we fix checks

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
    mainProgram = "asciinema";
  };
}
