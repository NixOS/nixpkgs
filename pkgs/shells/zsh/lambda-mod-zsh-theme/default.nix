{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "lambda-mod-zsh-theme-unstable";
  version = "2020-10-03";

  src = fetchFromGitHub {
    owner = "halfo";
    repo = "lambda-mod-zsh-theme";
    rev = "78347ea9709935f265e558b6345919d12323fbff";
    sha256 = "0fvxnvgbcvwii7ghvpj5l43frllq71wwjvfg7cqfmic727z001dh";
  };

  strictDeps = true;
  installPhase = ''
    install -Dm0644 lambda-mod.zsh-theme $out/share/zsh/themes/lambda-mod.zsh-theme
  '';

  meta = with lib; {
    description = "A ZSH theme optimized for people who use Git & Unicode-compatible fonts and terminals";
    homepage = "https://github.com/halfo/lambda-mod-zsh-theme/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
