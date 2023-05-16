{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-vi-mode";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-QE6ZwwM2X0aPqNnbVrj0y7w9hmuRf0H1j8nXYwyoLo4=";
=======
    sha256 = "sha256-KQ7UKudrpqUwI6gMluDTVN0qKpB15PI5P1YHHCBIlpg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp *.zsh $out/share/${pname}/
  '';

  meta = with lib; {
    homepage = "https://github.com/jeffreytse/zsh-vi-mode";
    license = licenses.mit;
    description = "A better and friendly vi(vim) mode plugin for ZSH.";
    maintainers = with maintainers; [ kyleondy ];
  };
}
