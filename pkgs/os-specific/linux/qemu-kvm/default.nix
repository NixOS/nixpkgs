{ stdenv, fetchurl, zlib, SDL, alsaLib, pkgconfig, pciutils, libuuid }:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "qemu-kvm-0.12.2";
   
  src = fetchurl {
    url = "mirror://sourceforge/kvm/${name}.tar.gz";
    sha256 = "0nmg9dp3h040dkxq5vv4i7ip76v98rnhzqwy4pd88zznawc2k9l2";
  };

  patches = [ ./unix-domain.patch ./smb-tmpdir.patch ];

  buildInputs = [ zlib SDL alsaLib pkgconfig pciutils libuuid ];

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
