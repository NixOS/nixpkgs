{ stdenv, lib, fetchFromGitLab, ncurses, pkg-config, nix-update-script }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  pname = "cbonsai";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jc34j627pnyjgs8hjxqaa89j24gyf0rq9w61mkhgg0kria62as7";
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
