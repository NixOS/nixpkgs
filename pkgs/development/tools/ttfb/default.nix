{ darwin
, fetchCrate
, lib
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ttfb";
  version = "1.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Cdup65w31wF1RZu0g4/msHfLESrNTcuCU5kxkk0gnW8=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoHash = "sha256-U8CG0GqnUwya+ZK0qXtOFZ/MbbqSvB5egX7XJKtl88g=";

  # The bin feature activates all dependencies of the binary. Otherwise,
  # only the library is build.
  buildFeatures = [ "bin" ];

  meta = {
    description = "CLI-Tool to measure the TTFB (time to first byte) of HTTP(S) requests";
    mainProgram = "ttfb";
    longDescription = ''
      ttfb measure the TTFB (time to first byte) of HTTP(S) requests. This includes data
      of intermediate steps, such as the relative and absolute timings of DNS lookup, TCP
      connect, and TLS handshake.
    '';
    homepage = "https://github.com/phip1611/ttfb";
    changelog = "https://github.com/phip1611/ttfb/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}

