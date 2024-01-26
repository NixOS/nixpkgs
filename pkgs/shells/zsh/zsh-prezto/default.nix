{ lib, stdenv, fetchFromGitHub, unstableGitUpdater, bash }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2024-01-18";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "ac356c8cf6af51f276483ae8bb8c9c4954183eb9";
    sha256 = "tyj92iZUFfS0xMaEkqIYvPJcksNlAQS4bKtDkWp0Ctc=";
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
