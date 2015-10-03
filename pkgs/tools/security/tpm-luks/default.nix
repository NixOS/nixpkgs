{ stdenv, fetchgit, autoreconfHook, gawk, trousers, cryptsetup, openssl }:

stdenv.mkDerivation rec {
  name = "tpm-luks-${version}";
  version = "git-2015-07-11";

  src = fetchgit {
    url = "https://github.com/momiji/tpm-luks";
    rev = "c9c5b7fdddbcdac1cd4d2ea6baddd0617cc88ffa";
    sha256 = "fdd451caddb4e51ede3f2406245e1ace57389596e85aa402c9f2606303707539";
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

