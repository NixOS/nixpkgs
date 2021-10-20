{ stdenv, lib, fetchFromGitLab, ncurses, pkg-config, nix-update-script }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  pname = "cbonsai";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kofJqMoBsvHrV3XfIQbSYO7OWpN7UgvrSs3WX3IVAJs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
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
