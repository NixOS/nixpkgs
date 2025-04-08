{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OCRfJh6vfAkL86J1GuLgfs57from3fx0NS1Bh1+/oXE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aEjsBhm0iPysA1Wz1Ea7rtX0g/yH/rklUkYV/Elxcq8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  # device::test_physical_device_name test fails on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # ofborg sometimes fails with "Resource temporarily unavailable"
    "--skip=cache::test::return_none_if_different_transform_was_used"
  ];

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    changelog = "https://github.com/pkolaczk/fclones/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      cyounkins
      figsoda
    ];
    mainProgram = "fclones";
  };
}
