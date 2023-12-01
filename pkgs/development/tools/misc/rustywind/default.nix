{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-3VG3EIcNp1fcNctrQO+mcGkAObHYPZQGdU83mi7WxPs=";
  };

  cargoHash = "sha256-hqGhh3YZ8Pz0hhC+HNdwc7PZVzGeMZqmctVjbQx7SQo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
