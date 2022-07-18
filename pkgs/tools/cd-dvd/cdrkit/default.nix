{lib, stdenv, fetchurl, cmake, libcap, zlib, bzip2, perl}:

stdenv.mkDerivation rec {
  pname = "cdrkit";
  version = "1.1.11";

  src = fetchurl {
    url = "http://cdrkit.org/releases/cdrkit-${version}.tar.gz";
    sha256 = "1nj7iv3xrq600i37na9a5idd718piiiqbs4zxvpjs66cdrsk1h6i";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libcap zlib bzip2 perl ];

  hardeningDisable = [ "format" ];

  # efi-boot-patch extracted from http://arm.koji.fedoraproject.org/koji/rpminfo?rpmID=174244
  patches = [ ./include-path.patch ./cdrkit-1.1.9-efi-boot.patch ./cdrkit-1.1.11-fno-common.patch ];

  postInstall = ''
    # file name compatibility with the old cdrecord (growisofs wants this name)
    ln -s $out/bin/genisoimage $out/bin/mkisofs
    ln -s $out/bin/wodim $out/bin/cdrecord
  '';

  cmakeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ "-DBITFIELDS_HTOL=0" ];

  makeFlags = [ "PREFIX=\$(out)" ];

  meta = {
    description = "Portable command-line CD/DVD recorder software, mostly compatible with cdrtools";

    longDescription = ''
      Cdrkit is a suite of programs for recording CDs and DVDs,
      blanking CD-RW media, creating ISO-9660 filesystem images,
      extracting audio CD data, and more.  The programs included in
      the cdrkit package were originally derived from several sources,
      most notably mkisofs by Eric Youngdale and others, cdda2wav by
      Heiko Eissfeldt, and cdrecord by Jörg Schilling.  However,
      cdrkit is not affiliated with any of these authors; it is now an
      independent project.
    '';

    homepage = "http://cdrkit.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
