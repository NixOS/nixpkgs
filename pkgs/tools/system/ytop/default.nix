{ stdenv, rustPlatform, fetchFromGitHub, IOKit }:

assert stdenv.isDarwin -> IOKit != null;

rustPlatform.buildRustPackage rec {
  pname = "ytop";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "cjbassi";
    repo = pname;
    rev = version;
    sha256 = "02cpn5257yrmbakx3mlqs97kfambbn9ljb60jbqr1b9w24kd6zgf";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  cargoSha256 = "0alqzy9gbj9m4l7xj1jsrnl09pv6z7c73gq787cqwn0gj93aaj19";

  meta = with stdenv.lib; {
    description = "A TUI system monitor written in Rust";
    homepage = "https://github.com/cjbassi/ytop";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
