{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-better-npm-completion";
  version = "unstable-2017-07-02";

  src = fetchFromGitHub {
    owner = "lukechilds";
    repo = pname;
    rev = "b61f6bb4e640728c42ae84ca55a575ee88c60fe8";
    sha256 = "00c1gdsam0z6v09fvz7hyl0zgmgnwbf59i1yrbkrz08frjlr16ax";
  };

  installPhase = ''
    install -D -m 0444 zsh-better-npm-completion.plugin.zsh \
      $out/share/zsh/plugins/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh
  '';

  meta = with stdenv.lib; {
    description = "Better completion for npm";
    homepage = https://github.com/lukechilds/zsh-better-npm-completion;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ gerschtli ];
  };
}
