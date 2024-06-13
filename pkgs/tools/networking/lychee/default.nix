{ callPackage
, lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
, SystemConfiguration
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "lychee";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "lycheeverse";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L1tvP2lZsFD2swhP1MetQFxxxA+EbrI4aDYTJwbpkVI=";
  };

  cargoHash = "sha256-SQ9Dgtg3TKAaj9XkpEzA13U8CumGOlpwiW+Lv6leQW4=";

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

  passthru.tests = {
    # NOTE: These assume that testers.lycheeLinkCheck uses this exact derivation.
    #       Which is true most of the time, but not necessarily after overriding.
    ok = callPackage ./tests/ok.nix { };
    fail = callPackage ./tests/fail.nix { };
    fail-emptyDirectory = callPackage ./tests/fail-emptyDirectory.nix { };
    network = testers.runNixOSTest ./tests/network.nix;
  };

  meta = with lib; {
    description = "Fast, async, stream-based link checker written in Rust";
    homepage = "https://github.com/lycheeverse/lychee";
    downloadPage = "https://github.com/lycheeverse/lychee/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ totoroot tuxinaut ];
    mainProgram = "lychee";
  };
}
