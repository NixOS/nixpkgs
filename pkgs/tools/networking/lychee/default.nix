{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JUyoOtlypDWK6HxsonVzbfQAdcXk728a8gVI/5GI2fs=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "criterion-0.4.0" = "sha256-0EKLRdxbH2czkZjmuaYLzkTBU687y6Iw9yqNV2TbsDw=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  checkFlags = [
    #  Network errors for all of these tests
    # "error reading DNS system conf: No such file or directory (os error 2)" } }
    "--skip=archive::wayback::tests::wayback_suggestion"
    "--skip=archive::wayback::tests::wayback_suggestion_unknown_url"
    "--skip=cli::test_dont_dump_data_uris_by_default"
    "--skip=cli::test_dump_data_uris_in_verbose_mode"
    "--skip=cli::test_exclude_example_domains"
    "--skip=cli::test_local_dir"
    "--skip=cli::test_local_file"
    "--skip=client::tests"
    "--skip=collector::tests"
    "--skip=src/lib.rs"
  ];

  meta = with lib; {
    description = "A fast, async, stream-based link checker written in Rust";
    homepage = "https://github.com/lycheeverse/lychee";
    downloadPage = "https://github.com/lycheeverse/lychee/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ totoroot tuxinaut ];
  };
}
