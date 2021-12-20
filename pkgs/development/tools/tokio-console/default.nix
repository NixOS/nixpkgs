{ lib
, fetchFromGitHub
, rustPlatform
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tokio-console";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tokio-rs";
    repo = "console";
    rev = "tokio-console-v${version}";
    sha256 = "sha256-1wxRTdDmgTlGJ3W1txDA/3Rnccs3KBw55vprrGaVnkg=";
  };

  cargoSha256 = "sha256-RScu5V55OowwWHi3MLjW8DPlTMA/IEBYFt4VUDUHPKo=";

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "A debugger for asynchronous Rust code";
    homepage = "https://github.com/tokio-rs/console";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ max-niederman ];
  };
}

