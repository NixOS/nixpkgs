{ stdenv, fetchFromGitHub, kernel, kmod }:

# TODO: look at the other kernel modules packages and see if you find improvements to do

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "2019-08-26";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "d65e76e84cfd8169591fc2a0a7c9219fa19da1b5";
    sha256 = "1s48qpwybwh5pwqas2d1v2a7x4r97sm4hr9i4902r1d7h384bv17";
  };
  

  unpackPhase = ''
    mkdir -p $out/build/src
    cp -r $src/* $out/build
  '';

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"
    cp $out/build/src/tuxedo_keyboard.ko $out/lib/modules/${kernel.modDirVersion}
    rm -rf $out/build
  '';

  meta = {
    description = "Full color keyboard driver for tuxedo computers laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.blanky0230 ];
  };
}
