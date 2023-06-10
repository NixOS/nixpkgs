{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7XixwONEgALMEQlF+SAzx8SO79GrNE8YBX2bDcslVdE=";
  };

  cargoHash = "sha256-hsidW0T8a6Bj8g+ybm3XX0Ddha+z4/DzHBSQD1jRa3A=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins figsoda msfjarvis ];
  };
}
