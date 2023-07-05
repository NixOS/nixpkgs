{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.26.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
    sha256 = "sha256-8Z83VW45Sb29PUE5oyJdELD25tAKkcr0zXfZDgkNikk=";
  };

  cargoHash = "sha256-QgzKmbYEmUr3qwSp58/dYwwz2tJeoJlMZfrp1vB0zjo=";

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "A window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
