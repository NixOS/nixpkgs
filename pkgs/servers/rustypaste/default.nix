{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kk9SDGDTCq1qHew9yrf1HmYAhse5mB4AqH/Oo/lc0dc=";
  };

  cargoHash = "sha256-6YTdOb1JvP5yTD1FVpHGG3C+hgiuTUiy05s+e3k8cdI=";

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
