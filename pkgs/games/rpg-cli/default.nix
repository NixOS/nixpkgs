{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "unstable-2021-05-27";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    # certain revision because the Cargo.lock was checked-in in that commit
    rev = "4d8a1dac79a1d29d79c0c874475037769dcef5a1";
    sha256 = "sha256-qfj1uij9lYyfyHFUnVi9I0ELOoObjFG2NS9UreC/xio=";
  };

  cargoSha256 = "sha256-I+rSfuiGFdzA5zqPfvMPcERaQfiX92LW2NKjazWh9c4=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
    mainProgram = "rpg-cli";
  };
}
