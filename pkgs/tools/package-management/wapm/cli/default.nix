{ lib
, fetchFromGitHub
, perl
, libiconv
, openssl
, rustPlatform
, Security
, stdenv
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "wapm-cli";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${version}";
    sha256 = "sha256-T7YEe8xg5iwI/npisW0m+6FLi+eaAQVgYNe6TvMlhAs=";
  };

  cargoSha256 = "sha256-r4123NJ+nxNOVIg6svWr636xbxOJQ7tp76JoAi2m9p8=";

  nativeBuildInputs = [ perl ];

  buildInputs = [ libiconv openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "A package manager for WebAssembly modules";
    homepage = "https://docs.wasmer.io/ecosystem/wapm";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lucperkins ];
  };
}
