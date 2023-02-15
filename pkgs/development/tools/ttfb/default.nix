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
  version = "1.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-o7kzQ8jtAqDwTUPtjeNqgotxREeWl7jQG+EDrYWJL/Q=";
  };

  cargoSha256 = "sha256-ayyYrrFDVOYVjVo5TLaRn2mvmywe5BjQ7kRVV2r0iK8=";

  # The bin feature activates all dependencies of the binary. Otherwise,
  # only the library is build.
  buildFeatures = [ "bin" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI-Tool to measure the TTFB (time to first byte) of HTTP(S) requests";
    longDescription = ''
      This crate measures the times of DNS lookup, TCP connect, TLS handshake, and HTTP's TTFB
      for a given IP or domain.
    '';
    homepage = "https://github.com/phip1611/ttfb";
    changelog = "https://github.com/phip1611/ttfb/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ phip1611 ];
  };
}

