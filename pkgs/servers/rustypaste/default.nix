{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qzSrxkq63SFcP/sQeORqG9+c+ct/n29jdIFUL9jut0w=";
  };

  cargoHash = "sha256-EDnc3P4sIpUyCDSozvaVeWI3y2KWDXKVcnkZ7M3Xx4w=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # Some tests need network
  checkFlags = [
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_file"
    "--skip=server::tests::test_upload_remote_file"
    "--skip=util::tests::test_get_expired_files"
  ];

  meta = with lib; {
    description = "A minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
