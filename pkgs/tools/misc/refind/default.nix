{ stdenv, fetchurl, gnu_efi, unzip }:

let version = "0.4.5"; in

stdenv.mkDerivation {
  name = "refind-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/refind/refind-src-${version}.zip";
    sha256 = "05nbalsl5csgph0v2amzgay9k2vzm47z8n1n6blbh9hvb7j5vn2c";
  };

  buildInputs = [ unzip ];

  buildFlags = [ "prefix=" "EFIINC=${gnu_efi}/include/efi" "GNUEFILIB=${gnu_efi}/lib" "EFILIB=${gnu_efi}/lib" "EFICRT0=${gnu_efi}/lib" "LOCAL_CFLAGS=-I${gnu_efi}/include" ];

  installPhase = ''
    mkdir -pv $out
    install -v -m644 refind/refind*.efi refind.conf-sample $out
    mv -v icons $out
  '';

  meta = {
    description = "An EFI boot manager";

    homepage = http://www.rodsbooks.com/refind/;

    license = "GPLv3+";

    maintainers = with stdenv.lib.maintainers; [ shlevy ];

    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
