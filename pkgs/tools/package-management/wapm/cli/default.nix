{ lib
, fetchFromGitHub
, libiconv
, openssl
, rustPlatform
, Security
, stdenv
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "wapm-cli";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${version}";
    sha256 = "sha256-BKBd1tJwV4VOjRnAx/spQy3LIXzujrO2SS5eA1uybNA=";
  };

  cargoSha256 = "sha256-dv04AXOnzizjq/qx3qy524ylQHgE4gIBgeYI+2IRTug=";

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
