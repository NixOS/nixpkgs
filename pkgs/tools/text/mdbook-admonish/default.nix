{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pks33QDAPocUjZTWRS69g9ZkubMqzQezYtJb0UNnd3Q=";
  };

  cargoHash = "sha256-HXUPdur45CkrzQrCi8YRlyKjk++GRFCcJwzfoX2ix+M=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman Frostman matthiasbeyer ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
