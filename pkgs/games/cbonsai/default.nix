{ stdenv, lib, fetchFromGitLab, ncurses, pkg-config, nix-update-script }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  pname = "cbonsai";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UTjbc0kGHOQse4sZF94p4LAwMk9vsZg1QHq8iuDcTDk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];
  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Grow bonsai trees in your terminal";
    homepage = "https://gitlab.com/jallbrit/cbonsai";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.unix;
  };
}
