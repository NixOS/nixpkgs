{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "toml2json";
  version = "1.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-TxTxKHf5g+mBXDq147T5tuwCqyfyoz6Mj55g1tlgRDY=";
  };

  cargoHash = "sha256-EYp30TMIpzSCkPIqqdc7sGpfaWs9OLi9ey7DoPE4jzI=";

  meta = with lib; {
    description = "A very small CLI for converting TOML to JSON";
    homepage = "https://github.com/woodruffw/toml2json";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rvarago ];
  };
}
