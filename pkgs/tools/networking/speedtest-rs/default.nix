{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "speedtest-rs";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nelsonjchen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-/d6A+Arlcc3SCKPSkYXwvqY2BRyAbA33Ah+GddHcc5M=";
  };

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [ pkg-config ];

  cargoSha256 = "sha256-4TJEM+oMjx/aaZgY2Y679pYFTdEWWFpWDYrK/o2b5UM=";

  meta = with lib; {
    description = "Command line internet speedtest tool written in rust";
    homepage = "https://github.com/nelsonjchen/speedtest-rs";
    changelog = "https://github.com/nelsonjchen/speedtest-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
