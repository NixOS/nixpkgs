{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "toml2json";
  version = "1.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-9q2HtNzsRO0/5gcmxUfWuQlWsfvw/A21WEXZlifCUjY=";
  };

  cargoHash = "sha256-laOM7LpmsCpLcm4kPRsJiXHoKR58RCuQxVO5Z78beWI=";

  meta = with lib; {
    description = "A very small CLI for converting TOML to JSON";
    homepage = "https://github.com/woodruffw/toml2json";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ rvarago ];
  };
}
