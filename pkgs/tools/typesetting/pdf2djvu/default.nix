{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, gettext
, libtool
, pkg-config
, djvulibre
, exiv2
, fontconfig
, graphicsmagick
, libjpeg
, libuuid
, poppler
}:

stdenv.mkDerivation rec {
  version = "0.9.17.1";
  pname = "pdf2djvu";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = "pdf2djvu";
    rev = version;
    sha256 = "1igabfy3fd7qndihmkfk9incc15pjxpxh2cn5pfw5fxfwrpjrarn";
  };

  patches = [
    # Not included in 0.9.17.1, but will be in the next version.
    (fetchpatch {
      name = "no-poppler-splash.patch";
      url = "https://github.com/jwilk/pdf2djvu/commit/2ec7eee57a47bbfd296badaa03dc20bf71b50201.patch";
      sha256 = "03kap7k2j29r16qgl781cxpswzg3r2yn513cqycgl0vax2xj3gly";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    djvulibre
    exiv2
    fontconfig
    graphicsmagick
    libjpeg
    libuuid
    poppler
  ];

  postPatch = ''
    substituteInPlace private/autogen \
      --replace /usr/share/gettext ${gettext}/share/gettext \
      --replace /usr/share/libtool ${libtool}/share/libtool

    substituteInPlace configure.ac \
      --replace '$djvulibre_bin_path' ${djvulibre.bin}/bin
  '';

  preAutoreconf = ''
    private/autogen
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Creates djvu files from PDF files";
    homepage = "https://jwilk.net/software/pdf2djvu";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
