{ lib, stdenv
, fetchFromGitHub

, autoconf
, automake
, libtool
, pkg-config

, file
, icu
, gumbo
, xz
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

  nativeBuildInputs = [ automake autoconf libtool pkg-config ];
  buildInputs = [ file icu gumbo xz zimlib zlib xapian ];
  setSourceRoot = ''
    sourceRoot=$(echo */zimwriterfs)
  '';
  preConfigure = "./autogen.sh";

  meta = {
    description = "A console tool to create ZIM files";
    homepage = "http://git.wikimedia.org/log/openzim";
    maintainers = with lib.maintainers; [ robbinch ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; [ linux ];
  };
}
