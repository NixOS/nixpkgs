{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "sha256-pcVxUX6CPIE5GJniXbAiwZQjwv2eer8LevFl6gASKmM=";
  };

  cargoSha256 = "sha256-4DB3Zj9awmKX5t1zCgWxetz/+tl6ojpCEKxWpZFlMcw=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
