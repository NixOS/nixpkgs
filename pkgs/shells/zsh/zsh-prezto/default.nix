{ lib, stdenv, fetchFromGitHub, unstableGitUpdater, bash }:

stdenv.mkDerivation rec {
  pname = "zsh-prezto";
<<<<<<< HEAD
  version = "unstable-2023-06-22";
=======
  version = "unstable-2023-04-13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sorin-ionescu";
    repo = "prezto";
<<<<<<< HEAD
    rev = "c9c716e9c11938a1aff2f30230d4dc1da38dc564";
    sha256 = "QwFWQMg9Q67eKkzGVz4zmcXtPcuLvFTUlagVxDN/2h4=";
=======
    rev = "da87c79b3a35f5a4a504ea331e9ec52b4f786976";
    sha256 = "EW1roiFaSgbXWYtc5Hxgj7m/ph6g1g225nXbvp0rtsw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
