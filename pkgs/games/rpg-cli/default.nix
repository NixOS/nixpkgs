{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "0rbj27zd7ydkvnyszd56hazj64aqqrwn34fsy4jymk50lvicwxjg";
  };

  cargoSha256 = "sha256-VftJgRqrFwTElp2/e+zQYZOLZPjbc9C8SZ4DlBEtRvQ=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
