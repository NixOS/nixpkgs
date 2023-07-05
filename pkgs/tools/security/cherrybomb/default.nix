{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cherrybomb";
  version = "1.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qZ1eKcRAwCzrzvw6QR28oZ8sGnsXmoOW/bWLQTlpqlo=";
  };

  cargoHash = "sha256-eosK7MQ3UB8rxKHCrb3s3+BVarv19h0cL+uzwg95Hc8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A CLI tool that helps you avoid undefined user behavior by validating your API specifications";
    homepage = "https://github.com/blst-security/cherrybomb";
    changelog = "https://github.com/blst-security/cherrybomb/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
