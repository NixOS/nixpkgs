{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "sha256-rhG/EK68PWvQYoZdjhk0w7oNmh/QiTaAt4/WgEkgxEA=";
  };

  cargoSha256 = "sha256-YXQohmDmkClziaLkL2N4cGURZ0tewyt7BuNY4hS+a4w=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    mainProgram = "rpg-cli";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
  };
}
