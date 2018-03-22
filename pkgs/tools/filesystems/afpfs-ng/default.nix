{ stdenv, fetchFromGitHub, fuse, readline, libgcrypt, gmp }:

stdenv.mkDerivation rec {
  name = "afpfs-ng-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner  = "simonvetter";
    repo   = "afpfs-ng";
    rev    = "f6e24eb73c9283732c3b5d9cb101a1e2e4fade3e";
    sha256 = "125jx1rsqkiifcffyjb05b2s36rllckdgjaf1bay15k9gzhwwldz";
  };

  buildInputs = [ fuse readline libgcrypt gmp ];

  meta = with stdenv.lib; {
    homepage    = https://github.com/simonvetter/afpfs-ng;
    description = "A client implementation of the Apple Filing Protocol";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };

}
