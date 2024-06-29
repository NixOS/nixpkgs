{lib, stdenv, fetchpatch, fetchurl, libpng, perl, gettext }:

stdenv.mkDerivation rec {
  pname = "xcftools";
  version = "1.0.7";

  src = fetchurl {
    url = "http://henning.makholm.net/xcftools/xcftools-${version}.tar.gz";
    sha256 = "19i0x7yhlw6hd2gp013884zchg63yzjdj4hpany011il0n26vgqy";
  };

  buildInputs = [ libpng perl gettext ];

  patches = [
    (fetchpatch {
      name = "CVE-2019-5086.CVE-2019-5087.patch";
      url = "https://github.com/gladk/xcftools/commit/59c38e3e45b9112c2bcb4392bccf56e297854f8a.patch";
      sha256 = "sha256-a1Biv6viXzTSaLDzinOyu0HdDTUPsKITsdKu9B9Y8GE=";
    })
  ];

  postPatch = ''
    # Required if building with libpng-1.6, innocuous otherwise
    substituteInPlace xcf2png.c         \
      --replace png_voidp_NULL NULL     \
      --replace png_error_ptr_NULL NULL

    # xcfview needs mailcap and isn't that useful anyway
    sed -i -e '/BINARIES/s/xcfview//' Makefile.in
  '';

  meta = {
    homepage = "http://henning.makholm.net/software";
    description = "Command-line tools for converting Gimp XCF files";
    longDescription = ''
      A set of fast command-line tools for extracting information from
      the Gimp's native file format XCF.

      The tools are designed to allow efficient use of layered XCF
      files as sources in a build system that use 'make' and similar
      tools to manage automatic processing of the graphics.

      These tools work independently of the Gimp engine and do not
      require the Gimp to even be installed.
    '';
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
