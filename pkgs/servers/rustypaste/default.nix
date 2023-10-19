{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bVy3/Ot4cb2Tr+wEDtWD3W2FYlXQVQ6tYC8DDyCiivY=";
  };

  cargoHash = "sha256-lCpp1VM6G36mFCm3u+4trsdFszd8SbUEgK1iIm/LwQ4=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    # requires internet access
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_remote_file"
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
