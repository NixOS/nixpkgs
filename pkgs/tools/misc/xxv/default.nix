{ stdenv, lib, fetchFromGitHub, rustPlatform
, ncurses ? null
, darwin ? null }:

let useNcurses = !stdenv.hostPlatform.isWindows; in

assert useNcurses -> ncurses != null;

rustPlatform.buildRustPackage rec {
  pname   = "xxv";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner  = "chrisvest";
    repo   = pname;
    rev    = version;
    sha256 = "0ppfsgdigza2jppbkg4qanjhlkpnq7p115c4471vc6vpikpfrlk3";
  };

  cargoSha256 = "1gnyig87a0yqgkng52fpn6hv629vym6k7ydljnxrhb5phmj2qbqx";

  buildInputs = lib.optionals useNcurses [ ncurses ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ])
  ;

  # I'm picking pancurses for Windows simply because that's the example given in Cursive's
  # documentation for picking an alternative backend. We could just as easily pick crossterm.
  cargoBuildFlags = lib.optionals (!useNcurses) [ "--no-default-features" "--features pancurses-backend" ];

  meta = with lib; {
    description = "A visual hex viewer for the terminal";
    longDescription = ''
      XXV is a terminal hex viewer with a text user interface, written in 100% safe Rust.
    '';
    homepage    = "https://chrisvest.github.io/xxv/";
    license     = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ lilyball ];
    platforms   = platforms.all;
  };
}
