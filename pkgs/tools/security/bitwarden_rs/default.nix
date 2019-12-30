{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, Security, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "bitwarden_rs";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    sha256 = "1qhfm58x08q6sv9r5nqs0qryggcyrasjlxw3h1wb3j6aq474p6jf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security CoreServices ];

  RUSTC_BOOTSTRAP = 1;

  cargoSha256 = "03szl83r9mjn08mqkwah8fmzpszci8ay7ki69yx1rgv3zx7npnxk";

  cargoBuildFlags = [ "--features sqlite" ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An unofficial lightweight implementation of the Bitwarden server API using Rust and SQLite";
    homepage = https://github.com/dani-garcia/bitwarden_rs;
    license = licenses.gpl3;
    maintainers = with maintainers; [ msteen ];
    platforms = platforms.all;
  };
}
