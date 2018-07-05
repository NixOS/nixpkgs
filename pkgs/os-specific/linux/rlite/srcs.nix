{ stdenv, fetchFromGitHub }:

rec {
  version = "git-2018-04-28";
  src = fetchFromGitHub {
    owner = "rlite";
    repo = "rlite";
    rev = "9bbe6366b0a66605456afb6d4968678eb7255072";
    sha256 = "1rs9s69fw9xlp96asl5zdf9c01z2lzd1k4pwvdcda4zbji6nyhda";
  };

  prePatch = ''
    find . -name CMakeLists.txt -exec sed -i 's|usr/||g' '{}' ';'
    sed -e 's/REVISION=.*/REVISION="${src.rev}"/'           \
        -e 's/REVISION_DATE=.*/REVISION_DATE="${version}"/' \
        -i configure
  '';

  meta = with stdenv.lib; {
    description = "A light RINA implementation";
    homepage = https://github.com/rlite/rlite;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ rvl ];
    platforms = platforms.linux;
  };
}
