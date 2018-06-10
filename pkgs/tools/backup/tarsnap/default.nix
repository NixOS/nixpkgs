{ stdenv, fetchurl, openssl, zlib, e2fsprogs }:

let
  zshCompletion = fetchurl {
    url = "https://gist.githubusercontent.com/thoughtpolice/daa9431044883d3896f6/raw/282360677007db9739e5bf229873d3b231eb303a/tarsnap.zsh";
    sha256 = "0pawqwichzpz29rva7mh8lpx4zznnrh2rqyzzj6h7z98l0dxpair";
  };
in
stdenv.mkDerivation rec {
  name = "tarsnap-${version}";
  version = "1.0.39";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz";
    sha256 = "10i0whbmb345l2ggnf4vs66qjcyf6hmlr8f4nqqcfq0h5a5j24sn";
  };

  preConfigure = ''
    configureFlags="--with-bash-completion-dir=$out/etc/bash_completion.d"
  '';

  patchPhase = ''
    substituteInPlace Makefile.in \
      --replace "command -p mv" "mv"
  '';

  postInstall = ''
    # Install some handy-dandy shell completions
    install -m 444 -D ${zshCompletion} $out/share/zsh/site-functions/_tarsnap
  '';

  buildInputs = [ openssl zlib ] ++ stdenv.lib.optional stdenv.isLinux e2fsprogs ;

  meta = {
    description = "Online backups for the truly paranoid";
    homepage    = "http://www.tarsnap.com/";
    license     = "tarsnap";
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice roconnor ];
  };
}
