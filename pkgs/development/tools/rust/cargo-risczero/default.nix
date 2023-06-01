{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-risczero";
  version = "0.14.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-uZz0jJ3klaOrqzJ0BUVDHxl7lv6vt0GT6RgQuJeyeyk=";
  };

  cargoSha256 = "sha256-t++3+Ijn1ykjMcMsdoe/1xfaji+DQvhyiFe6M/Bpbt0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = with lib; {
    description = "Cargo extension to help create, manage, and test RISC Zero projects.";
    homepage = "https://risczero.com";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
