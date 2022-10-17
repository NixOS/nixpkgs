{ lib, stdenv, fetchFromGitHub, unstableGitUpdater, bash }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2022-04-05";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "2c663313168490d28f607738e962aa45ada0e26b";
    sha256 = "05n2801xqdxc5nx0709mak1pr73l7aq5azd9adm0ym7si3vl59sj";
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
