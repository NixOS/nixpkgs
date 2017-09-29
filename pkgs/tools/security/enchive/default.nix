{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "enchive-${version}";
  version = "3.3";
  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "enchive";
    rev = version;
    sha256 = "0i3b0v5dqz56m5ppzm3332yxkw17dxs2zpvf48769ljgjy74irfl";
  };

  makeFlags = ["PREFIX=$(out)"];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v "$src/enchive-mode.el" "$out/share/emacs/site-lisp/"
  '';

  meta = {
    description = "Encrypted personal archives";
    homepage = https://github.com/skeeto/enchive;
    license = stdenv.lib.licenses.unlicense;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
