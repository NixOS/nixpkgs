{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "conserve";
  version = "23.9.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "conserve";
    rev = "v${version}";
    hash = "sha256-QBGuLSW4Uek1ag+QwXvoI8IEDM3j1MAOpScb9tIWrfA=";
  };

  cargoHash = "sha256-fKEktRDydmLJdU2KMDn4T637ogdbvT3OwWCzyIVaymc=";

  meta = with lib; {
    description = "Robust portable backup tool in Rust";
    homepage = "https://github.com/sourcefrog/conserve";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
