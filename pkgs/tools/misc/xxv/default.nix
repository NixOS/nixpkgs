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

  cargoSha256 = "0pmpvlmy4pw252is34r9af1ysrp78xs8pz8cw4rys9s4fh2hmhjb";

  buildInputs = lib.optionals useNcurses [ ncurses ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ])
  ;

  # I'm picking pancurses for Windows simply because that's the example given in Cursive's
  # documentation for picking an alternative backend. We could just as easily pick crossterm.
  buildNoDefaultFeatures = !useNcurses;
  buildFeatures = lib.optional (!useNcurses) "pancurses-backend";

  meta = with lib; {
    description = "A visual hex viewer for the terminal";
    longDescription = ''
      XXV is a terminal hex viewer with a text user interface, written in 100% safe Rust.
    '';
    homepage    = "https://chrisvest.github.io/xxv/";
    license     = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ lilyball ];
    mainProgram = "xxv";
  };
}
