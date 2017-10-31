{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dynamic-colors-${version}";
  version = "0.2.2.1";

  src = fetchFromGitHub {
    owner  = "peterhoeg";
    repo   = "dynamic-colors";
    rev    = "v${version}";
    sha256 = "0qz76n5sspgpz6bz66jfkyr42da3skbpw9wbvxgm3ha343azfaiw";
  };

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/share/dynamic-colors/colorschemes \
      $out/share/bash-completion/completions \
      $out/share/zsh/site-packages

    install -m755 bin/dynamic-colors              $out/bin/
    install -m644 completions/dynamic-colors.bash $out/share/bash-completion/completions/dynamic-colors
    install -m644 completions/dynamic-colors.zsh  $out/share/zsh/site-packages/_dynamic-colors
    install -m644 colorschemes/*               -t $out/share/dynamic-colors/colorschemes

    substituteInPlace $out/bin/dynamic-colors \
      --replace /usr/share/dynamic-colors $out/share/dynamic-colors
  '';

  meta = with stdenv.lib; {
    description = "Change terminal colors on the fly";
    homepage    = https://github.com/peterhoeg/dynamic-colors;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
