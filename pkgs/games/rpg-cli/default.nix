{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "07ar7almaz005jch7zm63kxyxvk3bphi2gl88xsb2rk5srkbb2s2";
  };

  cargoSha256 = "sha256-wJPRI3jfV+v/XpIU9+j1jXlyfjkFCEHZdFJx/KMNT9o=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
