{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-autocomplete";
  version = "23.05.02";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-autocomplete";
    rev = version;
    sha256 = "sha256-HVt7JGkNxg9Kb29x95mxq/vtQ1dBbNeQlb9lK2qTBSI=";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-autocomplete.plugin.zsh $out/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    cp -R scripts $out/share/zsh-autocomplete/scripts
    cp -R functions $out/share/zsh-autocomplete/functions
  '';

  meta = with lib; {
    description = "Real-time type-ahead completion for Zsh. Asynchronous find-as-you-type autocompletion";
    homepage = "https://github.com/marlonrichert/zsh-autocomplete/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.leona ];
  };
}
