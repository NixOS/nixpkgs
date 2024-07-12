{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.2";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-PH7dP7Ytdgy28d2KLp8H3FCt7eFM4dchyEYqN1Yv7JI=";
  };

  cargoHash = "sha256-ex029iu7VZ3VtcGIqqX4ztn2ZXo0+yDv1JM9sz8vcJs=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
