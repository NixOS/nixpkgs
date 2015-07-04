{ stdenv, fetchgit, autoreconfHook, gawk, trousers, cryptsetup, openssl }:

stdenv.mkDerivation rec {
  name = "tpm-luks-${version}";
  version = "0.9pre";

  src = fetchgit {
    url = "https://github.com/shpedoikal/tpm-luks/";
    rev = "3fa3ea4bbd34b5b02e9271e775a338fa49dc834f";
    sha256 = "37a56f05ad492d3128b07b3cb9dbf85ba8a0dd791329323fb398eb1026dfc89c";
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

