{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
<<<<<<< HEAD
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bVy3/Ot4cb2Tr+wEDtWD3W2FYlXQVQ6tYC8DDyCiivY=";
  };

  cargoHash = "sha256-lCpp1VM6G36mFCm3u+4trsdFszd8SbUEgK1iIm/LwQ4=";
=======
  version = "0.8.4";

  src = fetchFromGitHub{
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tx2ipgvYDdCwcWFeZ/qgGXyKe+kHLuOgDAz/8vf2zEs=";
  };

  cargoHash = "sha256-/zji2sFaOweBo666LqfNRpO/0vi1eAGgOReeuvQIaEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

<<<<<<< HEAD
  dontUseCargoParallelTests = true;

  checkFlags = [
    # requires internet access
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_remote_file"
  ];

  __darwinAllowLocalNetworking = true;

=======
  # Some tests need network
  checkFlags = [
    "--skip paste::tests::test_paste_data"
    "--skip server::tests::test_upload_file"
    "--skip server::tests::test_upload_remote_file"
    "--skip util::tests::test_get_expired_files"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda seqizz ];
=======
    maintainers = with maintainers; [ seqizz ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
