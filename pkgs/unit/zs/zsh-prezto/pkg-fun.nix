{ lib, stdenv, fetchFromGitHub, unstableGitUpdater, bash }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2023-01-12";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "e50b93ca882aa58b0119b2e90818c4157e30c794";
    sha256 = "25mz5UMTCHAVjtUhQsWTMsAGAweAwwTdGNLHMp2LCBM=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  buildInputs = [ bash ];

  postPatch = ''
    # make zshrc aware of where zsh-prezto is installed
    sed -i -e "s|\''${ZDOTDIR:\-\$HOME}/.zprezto/|$out/share/zsh-prezto/|g" runcoms/zshrc
  '';

  installPhase = ''
    mkdir -p $out/share/zsh-prezto
    cp -R ./ $out/share/zsh-prezto
  '';

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "The configuration framework for Zsh";
    longDescription = ''
      Prezto is the configuration framework for Zsh; it enriches
      the command line interface environment with sane defaults,
      aliases, functions, auto completion, and prompt themes.
    '';
    homepage = "https://github.com/sorin-ionescu/prezto";
    license = licenses.mit;
    maintainers = with maintainers; [ holymonson ];
    platforms = platforms.unix;
  };
}
