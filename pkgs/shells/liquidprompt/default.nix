{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "liquidprompt";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7mnrXLqnCdOuS2aRs4tVLfO8SRFrqZHNM40gWE/CVFI=";
  };

  strictDeps = true;
  installPhase = ''
    install -D -m 0444 liquidprompt $out/bin/liquidprompt
    install -D -m 0444 liquidpromptrc-dist $out/share/doc/liquidprompt/liquidpromptrc-dist
    install -D -m 0444 liquid.theme $out/share/doc/liquidprompt/liquid.theme

    install -D -m 0444 liquidprompt.plugin.zsh \
      $out/share/zsh/plugins/liquidprompt/liquidprompt.plugin.zsh
    install -D -m 0444 liquidprompt \
      $out/share/zsh/plugins/liquidprompt/liquidprompt
  '';

  meta = with lib; {
    description = "A full-featured & carefully designed adaptive prompt for Bash & Zsh";
    homepage = "https://github.com/nojhan/liquidprompt";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ gerschtli ];
  };
}
