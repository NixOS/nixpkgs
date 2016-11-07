{ stdenv, fetchurl, xcbuild, libcxx }:

stdenv.mkDerivation {
  name = "adv_cmds";

  src = fetchurl {
    url = "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-163.tar.gz";
    sha256 = "12gbv35i09aij9g90p6b3x2f3ramw43qcb2gjrg8lzkzmwvcyw9q";
  };

  patchPhase = ''
    substituteInPlace adv_cmds.xcodeproj/project.pbxproj \
      --replace "FD201DC214369B4200906237 /* pkill.c in Sources */," ""
  '';

  buildInputs = [ xcbuild libcxx ];
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
