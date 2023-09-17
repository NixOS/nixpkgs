{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fblUr2gtlGMRAFbpWYDafskLmIls56e9b2GFD7ASZHM=";
  };

  cargoHash = "sha256-pvb/tZW4jqNSLgp+Ktakd3J1KVfCRtPgE0bgNst6ImQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "socks" ];

  meta = with lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    changelog = "https://github.com/NLnetLabs/routinator/blob/v${version}/Changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
