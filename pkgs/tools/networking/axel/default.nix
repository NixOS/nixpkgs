{ stdenv, fetchurl, autoreconfHook, gettext, libssl }:

stdenv.mkDerivation rec {
  name = "axel-${version}";
  version = "2.12";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/axel/axel_${version}.orig.tar.gz";
    sha256 = "12sa5whd5mjn1idd83hbhm0rmsh5bvhhgvv03fk5cgxynwkbprr8";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=$(out)/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = http://axel.alioth.debian.org/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
