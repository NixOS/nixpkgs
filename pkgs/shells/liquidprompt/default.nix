{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "liquidprompt";
  version = "unstable-2018-05-21";

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = pname;
    rev = "eda83efe4e0044f880370ed5e92aa7e3fdbef971";
    sha256 = "1p7ah3x850ajpq07xvxxd7fx2i67cf0n71ww085g32k9fwij4rd4";
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
    homepage = https://github.com/nojhan/liquidprompt;
    license = licenses.agpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ gerschtli ];
  };
}
