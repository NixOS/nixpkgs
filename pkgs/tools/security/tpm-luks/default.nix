{ stdenv, fetchgit, autoreconfHook, gawk, trousers, cryptsetup, openssl }:

stdenv.mkDerivation rec {
  name = "tpm-luks-${version}";
  version = "git-2015-07-11";

  src = fetchgit {
    url = "https://github.com/momiji/tpm-luks";
    rev = "c9c5b7fdddbcdac1cd4d2ea6baddd0617cc88ffa";
    sha256 = "1ms2v57f13r9km6mvf9rha5ndmlmjvrz3mcikai6nzhpj0nrjz0w";
  };

  buildInputs = [ autoreconfHook gawk trousers cryptsetup openssl ];

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out/$out/sbin $out/bin
    rm -r $out/nix
    '';

  meta = with stdenv.lib; {
    description = "LUKS key storage in TPM NVRAM";
    homepage    = https://github.com/shpedoikal/tpm-luks/;
    maintainers = [ maintainers.tstrobel ];
    platforms   = platforms.linux;
  };
}

