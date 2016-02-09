{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.5";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "10qsmfq2aprrxsm8sshpvzjjpxhmyv89mrik4clw9rprwxknfdq2";
  };

  buildInputs = [ gettext ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
