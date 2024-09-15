{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, sqlite
, zlib
, stdenv
, darwin
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "prqlc";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "prql";
    repo = "prql";
    rev = version;
    hash = "sha256-XW0LnBt4gSuLQ8AjNTh6Rsd11x/dh45CQe818EZKRRs=";
  };

  cargoHash = "sha256-BecxuAOW+znKNe0s+UDPiqJ84BZU1P+f16Q53I4eXkI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      openssl
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    PYO3_PYTHON = "${python3}/bin/python3";
  };

  # we are only interested in the prqlc binary
  postInstall = ''
    rm -r $out/bin/compile-files $out/bin/mdbook-prql $out/lib
  '';

  meta = with lib; {
    description = "CLI for the PRQL compiler - a simple, powerful, pipelined SQL replacement";
    homepage = "https://github.com/prql/prql";
    changelog = "https://github.com/prql/prql/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
