{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "1zajgzhhxigga5wc94bmbk8iwx7yc2jq3f0hqadfsa4f0wmpi0nf";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "1ka9d81ddzz52w75xdiwd2xkv1rlamyvvdax09wanb61zxxwm0i7";

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = "https://github.com/cjbassi/ytop";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
