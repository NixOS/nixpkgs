{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "1158nlg5b93jyljwvf9f2m8m3ph8sksk5dh9sfnvbiifbk4gizv7";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "11pcchwahcwdvmfwfs6j2zg23grlw538wfs90mvqy2mpccj7d3ys";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = https://github.com/cjbassi/ytop;
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
