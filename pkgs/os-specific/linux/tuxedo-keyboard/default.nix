{ stdenv, fetchFromGitHub, kernel, kmod }:

stdenv.mkDerivation rec {
  name = "tuxedo-keyboard-${kernel.version}-${version}";
  version = "2019-08-26";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "d65e76e84cfd8169591fc2a0a7c9219fa19da1b5";
    sha256 = "1s48qpwybwh5pwqas2d1v2a7x4r97sm4hr9i4902r1d7h384bv17";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace '/lib/modules/' "${kernel.dev}/lib/modules/"
    substituteInPlace Makefile --replace '$(shell uname -r)' "${kernel.modDirVersion}"
  '';

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"
    mv src/tuxedo_keyboard.ko $out/lib/modules/${kernel.modDirVersion}
  '';

  meta = with stdenv.lib; {
    description = "Full color keyboard driver for tuxedo computers laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.blanky0230 ];
  };
}
