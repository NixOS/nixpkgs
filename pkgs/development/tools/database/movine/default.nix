{ rustPlatform
, fetchFromGitHub
, lib
, stdenv
, pkg-config
, postgresql
, sqlite
, openssl
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "movine";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "byronwasti";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rms8np8zd23xzrd5avhp2q1ndhdc8f49lfwpff9h0slw4rnzfnj";
  };

  cargoSha256 = "sha256-4ghfenwmauR4Ft9n7dvBflwIMXPdFq1vh6FpIegHnZk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ postgresql sqlite ] ++ (
    if !stdenv.isDarwin then [ openssl ] else [ Security libiconv ]
  );

  meta = with lib; {
    description = "A migration manager written in Rust, that attempts to be smart yet minimal";
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
