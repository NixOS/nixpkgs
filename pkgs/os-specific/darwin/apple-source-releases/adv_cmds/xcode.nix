{ stdenv, fetchurl, xcbuild, libcxx }:

stdenv.mkDerivation {
  name = "adv_cmds";

  src = fetchurl {
    url = "https://opensource.apple.com/tarballs/adv_cmds/adv_cmds-163.tar.gz";
    sha256 = "12gbv35i09aij9g90p6b3x2f3ramw43qcb2gjrg8lzkzmwvcyw9q";
  };

  # remove pkill from build
  patchPhase = ''
    substituteInPlace adv_cmds.xcodeproj/project.pbxproj \
      --replace "FD201DC214369B4200906237 /* pkill.c in Sources */," ""
  '';

  # temporary install phase until xcodebuild has "install" support
  installPhase = ''
    mkdir -p $out/bin/

    for cmd in cap_mkdb finger fingerd gencat last locale lsvfs ps stty tabs tty whois
    do
      install adv_cmds-*/Build/Products/Release-*/$cmd $out/bin/$cmd
    done
  '';

  buildInputs = [ xcbuild libcxx ];

  # temporary fix for iostream issue
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-I${libcxx}/include/c++/v1";

  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ matthewbauer ];
  };
}
