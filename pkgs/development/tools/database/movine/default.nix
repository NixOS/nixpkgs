{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "movine";
  version = "0.11.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-wa2GfV2Y8oX8G+1LbWnb2KH/+QbUYL9GXgOOVHpzbN8=";
  };

  cargoHash = "sha256-brM6QObhl9W5SZ+79Kv9oNxnglO24BUgjPSQy9jV1/Q=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "A migration manager written in Rust, that attempts to be smart yet minimal";
    mainProgram = "movine";
    homepage = "https://github.com/byronwasti/movine";
    license = licenses.mit;
    longDescription = ''
      Movine is a simple database migration manager that aims to be compatible
      with real-world migration work. Many migration managers get confused
      with complicated development strategies for migrations. Oftentimes
      migration managers do not warn you if the SQL saved in git differs from
      what was actually run on the database. Movine solves this issue by
      keeping track of the unique hashes for the <literal>up.sql</literal> and
      <literal>down.sql</literal> for each migration, and provides tools for
      fixing issues. This allows users to easily keep track of whether their
      local migration history matches the one on the database.

      This project is currently in early stages.

      Movine does not aim to be an ORM.
      Consider <link xling:href="https://diesel.rs/">diesel</link> instead if
      you want an ORM.
    '';
    maintainers = with maintainers; [ netcrns ];
  };
}
