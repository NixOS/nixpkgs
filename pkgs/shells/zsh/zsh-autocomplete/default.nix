{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "23.07.13";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = version;
    sha256 = "sha256-0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    cp -R Completions $out/share/zsh-autocomplete/Completions
    cp -R Functions $out/share/zsh-autocomplete/Functions
  '';

  meta = with lib; {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion";
    homepage = "https://github.com/marlonrichert/zsh-autocomplete/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.leona ];
  };
}
