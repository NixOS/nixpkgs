{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  e2fsprogs,
  bzip2,
}:

let
  zshCompletion = fetchurl {
    url = "https://gist.githubusercontent.com/thoughtpolice/daa9431044883d3896f6/raw/282360677007db9739e5bf229873d3b231eb303a/tarsnap.zsh";
    sha256 = "0pawqwichzpz29rva7mh8lpx4zznnrh2rqyzzj6h7z98l0dxpair";
  };
in
stdenv.mkDerivation rec {
  pname = "tarsnap";
  version = "1.0.40";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz";
    sha256 = "1mbzq81l4my5wdhyxyma04sblr43m8p7ryycbpi6n78w1hwfbjmw";
  };

  preConfigure = ''
    configureFlags="--with-bash-completion-dir=$out/share/bash-completion/completions"
  '';

  patchPhase = ''
    substituteInPlace Makefile.in \
      --replace "command -p mv" "mv"
    substituteInPlace configure \
      --replace "command -p getconf PATH" "echo $PATH"
  '';

  postInstall = ''
    # Install some handy-dandy shell completions
    install -m 444 -D ${zshCompletion} $out/share/zsh/site-functions/_tarsnap
  '';

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optional stdenv.isLinux e2fsprogs ++ lib.optional stdenv.isDarwin bzip2;

  meta = {
    description = "Online backups for the truly paranoid";
    homepage = "http://www.tarsnap.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      roconnor
    ];
    mainProgram = "tarsnap";
  };
}
