{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "0.3.8";

  src = fetchCrate {
    inherit version pname;
    sha256 = "1a42kwbl886yymm3v7h6y957x5f4yi9j40jy4szg9k0iy8bsdfmh";
  };

  cargoSha256 = "0v7ric12agicppg5ax5q0vwbslw7kmxpinafvdjj5sc2ysinw1zm";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [ fpletz ivan ];
    license = with lib.licenses; [ cc0 asl20 ];
  };
}
