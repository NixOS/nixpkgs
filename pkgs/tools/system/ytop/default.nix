{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "1p746v9xrfm6avc6v9dvcnpckhvdizzf53pcg9bpcp0lw5sh85da";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "15cpi0b5yqjwi1liry2q17sn9hpc4xf9gn33ri3rs6ls5qs7j7pa";

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = "https://github.com/cjbassi/ytop";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
