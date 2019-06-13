{ stdenv, gnu-efi, openssl, sbsigntool, perl, perlPackages,
help2man, fetchgit }:
stdenv.mkDerivation rec {
  name = "efitools-${version}";
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

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git";
    rev = "v${version}";
    sha256 = "0jabgl2pxvfl780yvghq131ylpf82k7banjz0ksjhlm66ik8gb1i";
  };

  postPatch = ''
    sed -i -e 's#/usr/include/efi#${gnu-efi}/include/efi/#g' Make.rules
    sed -i -e 's#/usr/lib64/gnuefi#${gnu-efi}/lib/#g' Make.rules
    sed -i -e 's#$(DESTDIR)/usr#$(out)#g' Make.rules
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "Tools for manipulating UEFI secure boot platforms";
    homepage = "https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git";
    license = licenses.gpl2;
    maintainers = [ maintainers.grahamc ];
    platforms = platforms.linux;
  };
}
