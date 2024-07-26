{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7CZi76IQR6CIf3EnoysaTrVf2kIDP9sOBXL4kqFFHtY=";
  };

  cargoHash = "sha256-fAj/z21do0GV41MIn5hifEZyZPgrb288TRz55BFsdz8=";

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
    mainProgram = "rustypaste";
  };
}
