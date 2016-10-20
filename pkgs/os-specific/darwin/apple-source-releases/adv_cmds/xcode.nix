{ stdenv, fetchurl, xcbuild, xpc }:

stdenv.mkDerivation {
  name = "adv_cmds";

  src = fetchurl {
    url = "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-163.tar.gz";
    sha256 = "12gbv35i09aij9g90p6b3x2f3ramw43qcb2gjrg8lzkzmwvcyw9q";
  };

  patchPhase = ''
    substituteInPlace pkill/pkill.c \
      --replace '#include <xpc/xpc.h>' ""
  '';

  buildInputs = [ xcbuild xpc ];

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
