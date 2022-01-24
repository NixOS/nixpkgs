{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
  version = "unstable-2021-11-16";

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
    rev = "ecaed1cfa7591d2304d7eb5d69b42b54961a7145";
    sha256 = "+7KYBHmzXkdMgyj/x7o7Bf8f1DDFJ6nUMWe8vLUxbZo=";
    fetchSubmodules = true;
  };

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
