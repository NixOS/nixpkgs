{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-history-substring-search";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "0vjw4s0h4sams1a1jg9jx92d6hd2swq4z908nbmmm2qnz212y88r";
=======
    sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-history-substring-search.zsh \
      "$out/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  '';

  meta = with lib; {
    description = "Fish shell history-substring-search for Zsh";
    homepage = "https://github.com/zsh-users/zsh-history-substring-search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
