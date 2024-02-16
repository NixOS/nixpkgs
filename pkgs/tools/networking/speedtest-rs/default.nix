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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "nelsonjchen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-JKthXrosqDZh6CWEqT08h3ySPZulitDol7lX3Eo7orM=";
  };

  buildInputs = [ openssl ] ++
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-kUXHC/qXgukaUqaBykXB2ZWmfQEjzJuIyemr1ogVX1U=";

  meta = with lib; {
    description = "Command line internet speedtest tool written in rust";
    homepage = "https://github.com/nelsonjchen/speedtest-rs";
    changelog = "https://github.com/nelsonjchen/speedtest-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "speedtest-rs";
  };
}
