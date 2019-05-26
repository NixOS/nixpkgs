{ stdenv, lib, fetchurl, writeScript, file, cleanPackaging }:

let
  version = "0.3.4";
  sha256 = "00xbkp99x9v07r34w7m2p8gak5hdsdbka36n7a733rdrrkgf5z7r";

in stdenv.mkDerivation {
  name = "nettee-${version}";

  src = fetchurl {
    url = "http://saf.bio.caltech.edu/pub/software/linux_or_unix_tools/beta-nettee-${version}.tar.gz";
    inherit sha256;
  };

  meta = {
    homepage = "http://saf.bio.caltech.edu/nettee.html";
    description = ''Network "tee" program'';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ Profpatsch ];
    platforms = lib.platforms.linux;
  };

  outputs = [ "bin" "man" "doc" "out" ];

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
    ${cleanPackaging.commonFileActions {
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
      }} $doc/share/doc/nettee

    mkdir -p $man/share/man/{man1,man3}
    mv nettee.1 $man/share/man/man1
    mv nettee_cmd.3 $man/share/man/man3
  '';

  postFixup = ''
    ${cleanPackaging.checkForRemainingFiles}
  '';

}
