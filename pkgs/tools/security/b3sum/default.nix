{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.1.0";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-x5gdJLcRMnmd0VLbV8cU9vrA6Ef7GysTh25bXnw6tsE=";
  };

  cargoSha256 = "sha256-+JVivP4Kppb+AoVq4XhXp4k8Hb+e9uX4u5n8KXp0kfk=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
