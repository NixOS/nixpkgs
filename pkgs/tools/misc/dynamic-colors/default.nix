{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dynamic-colors-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "peterhoeg";
    repo = "dynamic-colors";
    rev = "v${version}";
    sha256 = "0nm0jv77hvdhdsbrh7j4ky7gx6qxcvl7k145mm9kf5ww0b40f6hv";
  };

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/share/colorschemes \
      $out/share/bash-completion/completions \
      $out/share/zsh/site-packages

    install -m755 bin/dynamic-colors              $out/bin/
    install -m644 completions/dynamic-colors.bash $out/share/bash-completion/completions/dynamic-colors
    install -m644 completions/dynamic-colors.zsh  $out/share/zsh/site-packages/_dynamic-colors
    install -m644 colorschemes/*               -t $out/share/colorschemes

    sed -e "s|/usr/share/dynamic-colors|$out/share|g" \
        -i $out/bin/dynamic-colors
  '';

  meta = {
    homepage = https://github.com/peterhoeg/dynamic-colors;
    license = stdenv.lib.licenses.mit;
    description = "Change terminal colors on the fly";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peterhoeg ];
  };
}
