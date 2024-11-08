{ stdenv, lib, fetchFromGitLab, ncurses, pkg-config, nix-update-script, scdoc }:

stdenv.mkDerivation rec {
  pname = "cbonsai";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "jallbrit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XFK6DiIb8CzVubTnEMkqRW8xZkX/SWjUsrfS+I7LOs8=";
  };

  nativeBuildInputs = [ pkg-config scdoc ];
  buildInputs = [ ncurses ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Grow bonsai trees in your terminal";
    mainProgram = "cbonsai";
    homepage = "https://gitlab.com/jallbrit/cbonsai";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.unix;
  };
}
