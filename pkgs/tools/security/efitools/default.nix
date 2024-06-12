{ lib, stdenv, gnu-efi, openssl, sbsigntool, perl, perlPackages,
help2man, fetchzip }:
stdenv.mkDerivation rec {
  pname = "efitools";
  version = "1.9.2";

  buildInputs = [
    gnu-efi
    openssl
    sbsigntool
  ];

  nativeBuildInputs = [
    perl
    perlPackages.FileSlurp
    help2man
  ];

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/efitools-v${version}.tar.gz";
    sha256 = "0jabgl2pxvfl780yvghq131ylpf82k7banjz0ksjhlm66ik8gb1i";
  };

  # https://github.com/ncroxon/gnu-efi/issues/7#issuecomment-2122741592
  patches = [
    ./aarch64.patch
  ];

  postPatch = ''
    sed -i -e 's#/usr/include/efi#${gnu-efi}/include/efi/#g' Make.rules
    sed -i -e 's#/usr/lib64/gnuefi#${gnu-efi}/lib/#g' Make.rules
    sed -i -e 's#$(DESTDIR)/usr#$(out)#g' Make.rules
    substituteInPlace lib/console.c --replace "EFI_WARN_UNKOWN_GLYPH" "EFI_WARN_UNKNOWN_GLYPH"
    patchShebangs .
  '';

  meta = with lib; {
    description = "Tools for manipulating UEFI secure boot platforms";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.grahamc ];
    platforms = platforms.linux;
  };
}
