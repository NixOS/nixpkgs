{ darwin
, fetchCrate
, lib
, openssl
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ttfb";
  version = "1.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-GxjG8pyE2rY0h1dpAo+HRUbP31I5Pm4h1fAb6R7V+qU=";
  };

  cargoHash = "sha256-YdbVtVKt0bKb1R5IQxf9J/0ZA3ZHH+oZ8ryX6f4cGsY=";

  # The bin feature activates all dependencies of the binary. Otherwise,
  # only the library is build.
  buildFeatures = [ "bin" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "CLI-Tool to measure the TTFB (time to first byte) of HTTP(S) requests";
    longDescription = ''
      This crate measures the times of DNS lookup, TCP connect, TLS handshake, and HTTP's TTFB
      for a given IP or domain.
    '';
    homepage = "https://github.com/phip1611/ttfb";
    changelog = "https://github.com/phip1611/ttfb/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}

