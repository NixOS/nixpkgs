{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "sha256-R0Yaxe7Z1gPH0pvfytl5lOJKDZi4hN/upY/baMLc3Aw=";
  };

  cargoSha256 = "sha256-pvhZlj1uy5DZV+RBnqkUlVQPdQqGhh0YLE9aGFS3s1g=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
