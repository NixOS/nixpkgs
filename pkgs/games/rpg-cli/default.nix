{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "rpg-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "facundoolano";
    repo = pname;
    rev = version;
    sha256 = "sha256-LRTHnYxjPraVISAERT6XJGKIA3YJIilgEwU6olq2CRc=";
  };

  cargoSha256 = "sha256-ZlQy/JiYKDKPCEWrAFvKV6WsAkk2zsPpfJADB+kPyuo=";

  # tests assume the authors macbook, and thus fail
  doCheck = false;

  meta = with lib; {
    description = "Your filesystem as a dungeon";
    homepage = "https://github.com/facundoolano/rpg-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
