{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    sha256 = "sha256-a2LJUWRQsUnwU0DZnO5T+geeVOBXPfsBptEMnO+jnFA=";
  };

  cargoSha256 = "sha256-IJqM9XuJSEZadYc38TnyVrszuL5noYktnlyVu7IBE5k=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
