{ stdenv, fetchurl, openssl, zlib, e2fsprogs }:

let
  bashCompletion = fetchurl {
    url = "https://gist.githubusercontent.com/thoughtpolice/daa9431044883d3896f6/raw/282360677007db9739e5bf229873d3b231eb303a/tarsnap.bash";
    sha256 = "1cj7m0n3sw9vlaz2dfvf0bgaxkv1pcc0l31zb4h5rmm8z6d33405";
  };

  zshCompletion = fetchurl {
    url = "https://gist.githubusercontent.com/thoughtpolice/daa9431044883d3896f6/raw/282360677007db9739e5bf229873d3b231eb303a/tarsnap.zsh";
    sha256 = "0pawqwichzpz29rva7mh8lpx4zznnrh2rqyzzj6h7z98l0dxpair";
  };
in
stdenv.mkDerivation rec {
  name = "tarsnap-${version}";
  version = "1.0.35";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz";
    sha256 = "16lc14rwrq84fz95j1g10vv0qki0qw73lzighidj5g23pib6g7vc";
  };

  postInstall = ''
    # Install some handy-dandy shell completions
    mkdir -p $out/etc/bash_completion.d $out/share/zsh/site-functions
    cp ${bashCompletion} $out/etc/bash_completion.d/tarsnap.bash
    cp ${zshCompletion}  $out/share/zsh/site-functions/_tarsnap
  '';

  buildInputs = [ openssl zlib e2fsprogs ];

  meta = {
    description = "Online backups for the truly paranoid";
    homepage    = "http://www.tarsnap.com/";
    license     = "tarsnap";
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice roconnor ];
  };
}
