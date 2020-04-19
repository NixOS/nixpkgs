{ stdenv, fetchurl, makeWrapper, ascii2binary, unicode-character-database }:

stdenv.mkDerivation rec {
  pname = "uniutils";
  version = "2.27";

  src = fetchurl {
    # The "normal" url gives a 404.
    # url = "https://billposer.org/Software/Downloads/${pname}-${version}.tar.bz2"
    # Use Debian's mirror instead:
    url = "mirror://debian/pool/main/u/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "15hmlsfwicdsqniqap0gz7dbv7a7bl9pkxhh0pkalrrsb8hsjqn6";
  };

  buildInputs = [ makeWrapper ];

  # Patching logic adapted from the AUR package:
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=uniutils
  postPatch = ''
    UNICODE="${unicode-character-database}/share/unicode/"

    # update the UCD
    gawk -f ./genunames.awk \
      $UNICODE/UnicodeData.txt > unames.c

    # update the blocks
    sed -i -e '
      /#include "unirange.h"/ a #include "blocks.c"
      /struct cr Range_Table/,/^};/ d
    ' unirange.c
    gawk -F'[;.].? *' '
      BEGIN { print "struct cr Range_Table[] = {" }
      END { print "};" }
      /^[0-9A-F]/ { print "{0x"$1",0x"$2",\""$3"\"}," }
    ' $UNICODE/Blocks.txt > blocks.c
  '';

  configurePhase = ''
    ./configure --prefix=$out
  '';

  buildPhase = ''
    make
  '';

  postFixup = ''
    wrapProgram "$out/bin/utf8lookup" \
      --prefix PATH ":" ${ascii2binary}/bin:$out/bin
  '';

  testPhase = ''
    cd $src
    make test
  '';

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "A set of programs for manipulating and analyzing Unicode text";
    homepage = "https://www.billposer.org/software.html";
    maintainers = with maintainers; [ synthetica ];
  };
}
