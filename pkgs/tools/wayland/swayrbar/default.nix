{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.5";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-uYQGwccSwqHJ1w8CyxXimmENnGx7e3EMA1MKZuZDTIk=";
  };

  cargoHash = "sha256-PdPaUqJUycUhleaND6XwKkRvwO0MHbvw5lzz95bdfCQ=";

  # don't build swayr
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sebtm ];
  };
}
