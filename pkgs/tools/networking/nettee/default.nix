{
  stdenv,
  lib,
  fetchurl,
  cleanPackaging,
}:

let
  version = "0.3.5";
  hash = "sha256-WeZ18CLexdWy8RlHNh0Oo/6KXxzShZT8/xklAWyB8ss=";

in
stdenv.mkDerivation {
  pname = "nettee";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/nettee/nettee-${version}.tar.gz";
    inherit hash;
  };

  meta = {
    homepage = "http://saf.bio.caltech.edu/nettee.html";
    description = ''Network "tee" program'';
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Profpatsch ];
    platforms = lib.platforms.linux;
    mainProgram = "nettee";
  };

  outputs = [
    "bin"
    "man"
    "doc"
    "out"
  ];

  patchPhase = ''
    # h_addr field was removed
    sed -e '1 i #define h_addr h_addr_list[0]' \
        -i nettee.c
  '';

  buildPhase = ''
    cat README.TXT
    mkdir -p $bin/bin
    $CC -o $bin/bin/nettee \
      -Wall -pedantic -std=c99\
      -D_LARGEFILE64_SOURCE -D_POSIX_SOURCE -D_XOPEN_SOURCE\
      nettee.c rb.c nio.c
  '';

  installPhase = ''
    ${
      cleanPackaging.commonFileActions {
        docFiles = [
          "*.html"
          "*.TXT"
          "LICENSE"
          "*.sh"
          "topology.txt"
          "beowulf.master"
          "topology_info"
        ];
        noiseFiles = [
          "*.c"
          "*.h"
          "nettee"
        ];
      }
    } $doc/share/doc/nettee

    mkdir -p $man/share/man/{man1,man3}
    mv nettee.1 $man/share/man/man1
    mv nettee_cmd.3 $man/share/man/man3
  '';

  postFixup = ''
    ${cleanPackaging.checkForRemainingFiles}
  '';

}
