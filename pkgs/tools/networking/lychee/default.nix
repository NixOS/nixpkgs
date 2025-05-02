{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-luc6rzNYhS+c5B4S3/cOvDqnRF+LfRDY1aw99hkF+nE=";
  };

  cargoHash = "sha256-kGdRz5m0L3v3DBeabYq1Zp0bEEPW5C0y+A7tTjWkCwM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

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
    mainProgram = "lychee";
  };
}
