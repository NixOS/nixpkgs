{ stdenv, edk2, fetchhg }:

let

  src = fetchhg {
    url = https://bitbucket.org/shlevy/nixosbootpkg;
    tag = "1ff4c2891c8c1eb03677a6f8b04b8d05807ec198";
    sha256 = "06zwy0g9a7g2sny7phvn2z76pb3wnw4vm9vsrjjaj7f7nzcsn13k";
  };

in

stdenv.mkDerivation (edk2.setup "NixosBootPkg/NixosBootPkg.dsc" {
  name = "NixosBootPkg-2012-03-15";

  unpackPhase = ''
    ln -sv ${src} NixosBootPkg
    ln -sv ${edk2.src}/MdePkg .
  '';

  meta = {
    description = "Sample UEFI firmware for QEMU and KVM";
    homepage = http://www.shealevy.com;
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
})
