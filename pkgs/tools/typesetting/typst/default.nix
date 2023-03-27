{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
  version = "23-03-21-2";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
    hash = "sha256-bJPGs/Bd9nKYDrCCaFT+20+1wTN4YdkV8bGrtOCR4tM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "biblatex-0.6.3" = "sha256-TfH2tk7B61HHqpdGY48TdPKelp4+78x+8LRFobAg8QA=";
      "comemo-0.1.0" = "sha256-zg056kUc8sVLQ8vvT4uOuRJnyrCORsGYUvsjBJEkFPg=";
      "hayagriva-0.1.1" = "sha256-HGQ+jNAnejxUBQNaqXPw57zfAC3qNXSWUVzDALZTXg0=";
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
      "lipsum-0.8.2" = "sha256-deIbpn4YM7/NeuJ5Co48ivJmxwrcsbLl6c3cP3JZxAQ=";
      "pixglyph-0.1.0" = "sha256-8veNF3rzV21ayzk9gh2x0mQA8nHGM662ohvh084a0vk=";
      "unicode-math-class-0.1.0" = "sha256-NkwDzj1SfUe570UcfotmVP6bIEYwiegZd0j8TPEWoOk=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  cargoBuildFlags = [ "-p" "typst-cli" ];
  cargoTestFlags = [ "-p" "typst-cli" ];

  # the build script tries to get the revision using git
  # which overwrites the environment variable set below
  postPatch = ''
    rm cli/build.rs
  '';

  # git revision used for `--version`
  # https://github.com/typst/typst/blob/b934a2fd83d63fc115c01f959e888c7bc1aa87e4/cli/build.rs#L7
  TYPST_HASH = "b934a2fd";

  meta = with lib; {
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://typst.app";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda kanashimia ];
  };
}
