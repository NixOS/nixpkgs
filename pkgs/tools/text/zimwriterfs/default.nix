{ stdenv
, fetchFromGitHub

, autoconf
, automake
, libtool
, pkgconfig

, file
, icu
, gumbo
, lzma
, xapian
, zimlib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zimwriterfs";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "wikimedia";
    repo = "openzim";
    rev = "${pname}-${version}";
    sha256 = "1vkrrq929a8s3m5rri1lg0l2vd0mc9n2fsb2z1g88k4n4j2l6f19";
  };

  nativeBuildInputs = [ automake autoconf libtool pkgconfig ];
  buildInputs = [ file icu gumbo lzma zimlib zlib xapian ];
  setSourceRoot = ''
    sourceRoot=$(echo */zimwriterfs)
  '';
  preConfigure = "./autogen.sh";

  meta = {
    description = "A console tool to create ZIM files";
    homepage = "http://git.wikimedia.org/log/openzim";
    maintainers = with stdenv.lib.maintainers; [ robbinch ];
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; [ linux ];
  };
}
