{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, CoreServices, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qnmz7sxbwnjdsl17h876szxd04z0q9arbl1ib45b6346x7mq8n4";
  };

  cargoSha256 = "1jnbf0a3bggjf0wapr9xdj9hwfpgki2csg7rhg5maqavm8m0mirm";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security libiconv ];

  # Requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
