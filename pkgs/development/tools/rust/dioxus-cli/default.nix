{ lib, fetchCrate, rustPlatform, openssl, pkg-config, stdenv, CoreServices }:
rustPlatform.buildRustPackage rec {
  pname = "dioxus-cli";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-SnmDOMxc+39LX6kOzma2zA6T91UGCnvr7WWhX+wXnLo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  cargoSha256 = "sha256-Mf/WtOO/vFuhg90DoPDwOZ6XKj423foHZ8vHugXakb0=";

  meta = with lib; {
    description = "CLI tool for developing, testing, and publishing Dioxus apps";
    homepage = "https://dioxuslabs.com";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xanderio ];
  };
}
