{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "f5a8cb456b74d4d71caf46037a356d2deee27b50";
    sha256 = "iikJ/U7amsmMgFIEYuIIIymNeWr4ag/QPeyQjBJ/lOY=";
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

  passthru.updateScript = unstableGitUpdater { };

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
