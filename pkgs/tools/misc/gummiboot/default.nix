{ stdenv, fetchurl, gnu_efi }:

stdenv.mkDerivation rec {
  name = "gummiboot-16";

  patches = [ ./no-usr.patch ];

  buildFlags = [
    "GNU_EFI=${gnu_efi}"
  ];

  installPhase = "mkdir -p $out/bin; mv gummiboot.efi $out/bin";

  src = fetchurl {
    url = "http://cgit.freedesktop.org/gummiboot/snapshot/${name}.tar.gz";
    sha256 = "1znvbxrhc7pkbhbw9bvg4zhfkp81q7fy4mq2jsw6vimccr7h29a0";
  };

  meta = {
    description = "A simple UEFI boot manager which executes configured EFI images";

    homepage = http://freedesktop.org/wiki/Software/gummiboot;

    license = stdenv.lib.licenses.lgpl21Plus;

    platforms = [ "x86_64-linux" ];
  };
}
