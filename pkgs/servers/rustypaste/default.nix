{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.7.1";

  src = fetchFromGitHub{
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NGrz08cpio745oVYtfNO1jpViYLaxZ9ZRXQdQG/f0oM=";
  };

  cargoSha256 = "sha256-UQNe2O664PXvcSu6MI5F8RdYJJholjF9iO2I5OSMm2A=";

  # Some tests need network
  checkFlags = [
    "--skip paste::tests::test_paste_data"
    "--skip server::tests::test_upload_file"
    "--skip server::tests::test_upload_remote_file"
    "--skip util::tests::test_get_expired_files"
  ];

  meta = with lib; {
    description = "A minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
