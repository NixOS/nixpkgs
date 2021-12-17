{ lib, stdenv, fetchgit, autoreconfHook, gawk, trousers, cryptsetup, openssl }:

stdenv.mkDerivation {
  pname = "tpm-luks";
  version = "unstable-2015-07-11";

  src = fetchgit {
    url = "https://github.com/momiji/tpm-luks";
    rev = "c9c5b7fdddbcdac1cd4d2ea6baddd0617cc88ffa";
    sha256 = "1ms2v57f13r9km6mvf9rha5ndmlmjvrz3mcikai6nzhpj0nrjz0w";
  };

  patches = [
    ./openssl-1.1.patch
    ./signed-ptr.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ gawk trousers cryptsetup openssl ];

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out/$out/sbin $out/bin
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "LUKS key storage in TPM NVRAM";
    homepage = "https://github.com/shpedoikal/tpm-luks/";
    maintainers = [ maintainers.tstrobel ];
    license = with licenses; [ gpl2Only ];
    platforms = platforms.linux;
  };
}

