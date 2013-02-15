{ stdenv, fetchurl, gnu_efi, unzip }:

stdenv.mkDerivation rec {
  name = "gummiboot-16";

  buildInputs = [ unzip ];

  patches = [ ./no-usr.patch ];

  buildFlags = [
    "GNU_EFI=${gnu_efi}"
  ] ++ stdenv.lib.optional (stdenv.system == "i686-linux") "ARCH=ia32";

  installPhase = "mkdir -p $out/bin; mv gummiboot.efi $out/bin";

  src = fetchurl {
    url = "http://cgit.freedesktop.org/gummiboot/snapshot/${name}.zip";
    sha256 = "0as5svmvsbz08qgbvns77qfb36xi9lx2138ikiinqv6finzm8fi1";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" "i686-linux" ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
