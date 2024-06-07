{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, testers
, Security
, surrealdb-migrations
, nix-update-script
}:

let
  pname = "surrealdb-migrations";
  version = "1.5.0";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Odonno";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x5WyaVHLVFCHWPqyEuaVSbeIaGXDB0o7h776udcC4DM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [ ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

   # Error: No such file or directory (os error 2)
   # failures:
   #   cli::apply::apply_initial_migrations
   #   cli::apply::apply_initial_schema_changes
   #   cli::apply::apply_new_migrations
   #   cli::apply::apply_new_schema_changes
   #   cli::apply::apply_should_skip_events_if_no_events_folder
   #   cli::apply::apply_with_db_configuration
   #   cli::apply::apply_with_skipped_migrations
   #   cli::list::list_blog_migrations
   #   cli::list::list_empty_migrations
   #   library::list::list_blog_migrations
   #   library::list::list_empty_migrations
   #   library::up::apply_initial_migrations
   #   library::up::apply_initial_schema_changes
   #   library::up::apply_new_migrations
   #   library::up::apply_new_schema_changes
   #   library::up::apply_should_skip_events_if_no_events_folder
   #   library::up_to::apply_with_skipped_migrations
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = surrealdb-migrations;
      command = "surrealdb-migrations --version";
    };
  };

  meta = with lib; {
    description = "An awesome SurrealDB migration tool, with a user-friendly CLI and a versatile Rust library that enables seamless integration into any project";
    homepage = "https://crates.io/crates/surrealdb-migrations";
    mainProgram = "surrealdb-migrations";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
