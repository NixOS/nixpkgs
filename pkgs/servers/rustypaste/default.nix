{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5yttOaDsWcRCFBzziOW4H1Nrs7/X/pGFlnPNUQRf+w8=";
  };

  cargoHash = "sha256-8lv0AGcV4LW6r+K0rIZNV0NPhX4j3+wbMw4JeJkNuXw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # Some tests need network
  checkFlags = [
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_index_with_landing_page_file_not_found"
    "--skip=server::tests::test_upload_file"
    "--skip=server::tests::test_upload_remote_file"
    "--skip=util::tests::test_get_expired_files"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda seqizz ];
  };
}
