{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WLuMG9gC2kSdyrYa0CNnInjetXph0OL/Jmjskih4tuw=";
  };

  cargoHash = "sha256-A651PTooQjITjxCLKPhnFSCxa27uesTOP8ZbAlRbOUk=";

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
    maintainers = with maintainers; [ figsoda seqizz ];
  };
}
