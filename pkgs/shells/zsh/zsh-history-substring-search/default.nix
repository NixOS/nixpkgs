{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-history-substring-search";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "v${version}";
    sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
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
