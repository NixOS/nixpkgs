{ stdenv, lib, pkg-config, openssl, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "hydra-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nlewo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fd3swdjx249971ak1bgndm5kh6rlzbfywmydn122lhfi6ry6a03";
  };
  cargoSha256 = "16446ppkvc6l8087x5m5kyy5gk4f7inyj7rzrfysriw4fvqxjsf3";

  buildInputs = [ openssl ]
                ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "A client for the Hydra CI";
    homepage = "https://github.com/nlewo/hydra-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gilligan lewo ];
  };

}
