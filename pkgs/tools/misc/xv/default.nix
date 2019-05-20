{ stdenv, fetchFromGitHub, rustPlatform, ncurses }:

rustPlatform.buildRustPackage rec {
  pname   = "xv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner  = "chrisvest";
    repo   = pname;
    rev    = "${version}";
    sha256 = "1cghg3ypxx6afllvwzc6j4z4h7mylapapipqghpdndrfizk7rsxi";
  };

  cargoSha256 = "0iwx9cxnxlif135s2v2hji8xil38xk5a1h147ryb54v6nabaxvjw";

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "A visual hex viewer for the terminal";
    longDescription = ''
      XV is a terminal hex viewer with a text user interface, written in 100% safe Rust.
    '';
    homepage    = https://chrisvest.github.io/xv/;
    license     = with licenses; [ asl20 ];
    maintainers = with maintainers; [ lilyball ];
    platforms   = platforms.all;
  };
}
