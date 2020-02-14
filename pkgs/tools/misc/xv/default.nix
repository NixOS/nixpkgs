{ stdenv, lib, fetchFromGitHub, rustPlatform
, ncurses ? null
, darwin ? null }:

let useNcurses = !stdenv.hostPlatform.isWindows; in

assert useNcurses -> ncurses != null;

rustPlatform.buildRustPackage rec {
  pname   = "xv";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner  = "chrisvest";
    repo   = pname;
    rev    = version;
    sha256 = "0x2yd21sr4wik3z22rknkx1fgb64j119ynjls919za8gd83zk81g";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0m69pcmnx3c3q7lgvbhxc8dl6lavv5ch4r6wg2bhdmapcmb4p7jq";

  buildInputs = lib.optionals useNcurses [ ncurses ]
  ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security ])
  ;

  # I'm picking pancurses for Windows simply because that's the example given in Cursive's
  # documentation for picking an alternative backend. We could just as easily pick crossterm.
  cargoBuildFlags = lib.optionals (!useNcurses) [ "--no-default-features" "--features pancurses-backend" ];

  meta = with lib; {
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
