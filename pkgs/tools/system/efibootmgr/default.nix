{stdenv, fetchurl, pciutils, perl, zlib}:

let version = "0.5.4"; in

stdenv.mkDerivation {
  name = "efibootmgr-${version}";

  buildInputs = [ pciutils zlib perl ];

  patches = [ ./arbitrary-filenames.patch ];
  
  src = fetchurl {
    url = "http://linux.dell.com/efibootmgr/permalink/efibootmgr-${version}.tar.gz";
    sha256 = "0wcfgf8x4p4xfh38m9x3njwsxibm9bhnmvpjj94lj9sk9xxa8qmm";
  };

  postPatch = ''
    substituteInPlace "./tools/install.pl" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  preBuild = ''
    export makeFlags="BINDIR=$out/sbin"
  '';

  meta = {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = http://linux.dell.com/efibootmgr/;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}

