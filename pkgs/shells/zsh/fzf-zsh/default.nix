{ lib, stdenv, fetchFromGitHub, fzf }:

stdenv.mkDerivation rec {
  pname = "fzf-zsh-unstable";
  version = "2019-09-09";

  src = fetchFromGitHub {
    owner = "Wyntau";
    repo = "fzf-zsh";
    rev = "829d7e40cc437dce8a6e234e259bbd4065e87124";
    sha256 = "1irjmxhcg1fm4g8p3psjqk7sz5qhj5kw73pyhv91njvpdhn9l26z";
  };

  strictDeps = true;
  postPatch = ''
    substituteInPlace fzf-zsh.plugin.zsh \
      --replace \
        'fzf_path="$( cd "$fzf_zsh_path/../fzf/" && pwd )"' \
        "fzf_path=${fzf}" \
      --replace \
        '$fzf_path/shell' \
        '${fzf}/share/fzf'
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm0644 fzf-zsh.plugin.zsh $out/share/zsh/plugins/fzf-zsh/fzf-zsh.plugin.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/wyntau/fzf-zsh";
    description = "wrap fzf to use in oh-my-zsh";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
