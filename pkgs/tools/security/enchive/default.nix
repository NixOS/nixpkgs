{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "enchive";
  version = "3.4";
  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "enchive";
    rev = version;
    sha256 = "0ssxbnsjx4mvaqimp5nzfixpxinhmi12z8lxdd8cj2361wbb54yk";
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
