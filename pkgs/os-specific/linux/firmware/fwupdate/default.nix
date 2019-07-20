{ efivar, fetchurl, gettext, gnu-efi, libsmbios, pkgconfig, popt, stdenv }:
let
  version = "12";
in stdenv.mkDerivation {
  name = "fwupdate-${version}";
  src = fetchurl {
    url = "https://github.com/rhinstaller/fwupdate/releases/download/${version}/fwupdate-${version}.tar.bz2";
    sha256 = "00w7jsg7wrlq4cpfz26m9rbv2jwyf0sansf343vfq02fy5lxars1";
  };

  patches = [
    ./do-not-create-sharedstatedir.patch
  ];

  NIX_CFLAGS_COMPILE = [ "-I${gnu-efi}/include/efi" ];

  # TODO: Just apply the disable to the efi subdir
  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "EFIDIR=nixos"
    "prefix=$(out)"
    "LIBDIR=$(out)/lib"
    "GNUEFIDIR=${gnu-efi}/lib"
    "ESPMOUNTPOINT=$(out)/boot"
  ];

  nativeBuildInputs = [
    pkgconfig
    gettext
  ];

  buildInputs = [
    gnu-efi
    libsmbios
    popt
  ];

  propagatedBuildInputs = [
    efivar
  ];

  # TODO: fix wrt cross-compilation
  preConfigure = ''
    arch=$(cc -dumpmachine | cut -f1 -d- | sed 's,i[3456789]86,ia32,' )
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gnu-efi}/include/efi/$arch"
  '';

  postInstall = ''
    rm -rf $out/src
    rm -rf $out/lib/debug
  '';

  meta = with stdenv.lib; {
    description = "Tools for using the ESRT and UpdateCapsule() to apply firmware updates";
    maintainers = with maintainers; [ ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
