{stdenv, fetchurl, zlib, SDL, alsaLib, pkgconfig, pciutils}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "qemu-kvm-0.12.1.2";
   
  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "1k5xx9rn0n311bgvl6g9c8h1bxj2nhjpjpzbngy0sf9hdjidnba7";
  };

  patches = [ ./unix-domain.patch ];

  buildInputs = [zlib SDL alsaLib pkgconfig pciutils];

  preBuild =
    ''
      # Don't use a hardcoded path to Samba.
      substituteInPlace ./net.h --replace /usr/sbin/smbd smbd
    '';
  
  postInstall =
    ''
      # extboot.bin isn't installed due to a bug in the Makefile.
      cp pc-bios/optionrom/extboot.bin $out/share/qemu/
    '';

  meta = {
    homepage = http://www.linux-kvm.org/;
    description = "A full virtualization solution for Linux on x86 hardware containing virtualization extensions";
  };
}
