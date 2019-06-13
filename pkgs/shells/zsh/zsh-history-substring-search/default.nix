{ stdenv, lib, fetchFromGitHub, zsh }:

stdenv.mkDerivation rec {
  name = "zsh-history-substring-search-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "v${version}";
    sha256 = "0lgmq1xcccnz5cf7vl0r0qj351hwclx9p80cl0qczxry4r2g5qaz";
  };

  installPhase = ''
    install -D zsh-history-substring-search.zsh \
      "$out/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  '';

  meta = with lib; {
    description = "Fish shell history-substring-search for Zsh";
    homepage = https://github.com/zsh-users/zsh-history-substring-search;
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
