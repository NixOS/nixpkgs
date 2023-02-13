{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.8.4";

  src = fetchFromGitHub{
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tx2ipgvYDdCwcWFeZ/qgGXyKe+kHLuOgDAz/8vf2zEs=";
  };

  cargoHash = "sha256-/zji2sFaOweBo666LqfNRpO/0vi1eAGgOReeuvQIaEQ=";

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
