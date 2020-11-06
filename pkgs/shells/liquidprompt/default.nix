{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "liquidprompt";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vlwwkdbkxjsjcfmcspmq3f163kf0x4mwa8svxkzgnn2g4kl41ja";
  };

  installPhase = ''
    install -D -m 0444 liquidprompt $out/bin/liquidprompt
    install -D -m 0444 liquidpromptrc-dist $out/share/doc/liquidprompt/liquidpromptrc-dist
    install -D -m 0444 liquid.theme $out/share/doc/liquidprompt/liquid.theme

    install -D -m 0444 liquidprompt.plugin.zsh \
      $out/share/zsh/plugins/liquidprompt/liquidprompt.plugin.zsh
    install -D -m 0444 liquidprompt \
      $out/share/zsh/plugins/liquidprompt/liquidprompt
  '';

  meta = with stdenv.lib; {
    description = "A full-featured & carefully designed adaptive prompt for Bash & Zsh";
    homepage = "https://github.com/nojhan/liquidprompt";
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ gerschtli ];
  };
}
