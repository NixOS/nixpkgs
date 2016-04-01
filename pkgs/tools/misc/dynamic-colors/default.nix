{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "dynamic-colors-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "peterhoeg";
    repo = "dynamic-colors";
    rev = "v${version}";
    sha256 = "061lh4qjk4671hwzmj55n3gy5hsi4p3hb30hj5bg3s6glcsbjpr5";
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
